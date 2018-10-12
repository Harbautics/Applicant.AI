#ifndef NETWORK_H
#define NETWORK_H

#include <stdlib.h>
#include <time.h>
#include <vector>
#include <string>
#include <ctime>
#include <fstream>
#include <random>
#include <utility>
#include <algorithm>
#include <Eigen/Dense>
#include <Eigen/Sparse>
#include "Cost.h"

using inout = std::pair<Eigen::VectorXd, Eigen::VectorXd>;
using nablas = std::pair<std::vector<Eigen::MatrixXd>, std::vector<Eigen::MatrixXd>>;

template <typename Cost, typename OutType>
class Network {
public:
	Network(std::vector<int> layers_in, Cost cost_in, OutType ot_in)
		: num_layers((int)layers_in.size()),
		cost(cost_in),
		layers(layers_in),
		ot(ot_in) {
		default_weight_initializer();
	}

	void default_weight_initializer() {
		double stdev = std::sqrt(1 / (double)layers.size());
		std::random_device rd;
		std::mt19937 e2(rd());
		std::normal_distribution<> weight_dist(0, stdev);
		std::normal_distribution<> bias_dist(0, 1);
		weights.reserve(layers.size() - 1);
		biases.reserve(layers.size() - 1);
		for (unsigned i = 1; i < layers.size(); ++i) {
			biases.emplace_back(Eigen::VectorXd(layers[i]));
			for (int j = 0; j < layers[i]; ++j) {
				biases[i-1](j) = bias_dist(e2);
			}
			weights.emplace_back(Eigen::MatrixXd(layers[i], layers[i - 1]));
			for (int j = 0; j < layers[i]; ++j) {
				for (int k = 0; k < layers[i - 1]; ++k) {
					weights[i-1](j, k) = weight_dist(e2);
				}
			}
		}
	}

	Eigen::VectorXd feedforward(Eigen::VectorXd a) {
		for (unsigned i = 0; i < weights.size() - 1; ++i) {
			//cout << ((weights[i] * a) + biases[i]) << endl;
			a = sigmoid((weights[i] * a) + biases[i]);
			//cout << a << endl;
		}
		a = ot.outputFN((weights[weights.size() - 1] * a) + biases[weights.size() - 1]);
		//cout << a << endl;
		return a;
	}

	void SGD(std::vector<inout> &training_data,
		int epochs,
		int mini_batch_size,
		double eta,
		double lambda = 0.0,
		std::vector<inout> &evaluation_data = std::vector<inout>(),
		bool monitor_evaluation_cost = false,
		bool monitor_evaluation_accuracy = false,
		bool monitor_training_cost = false,
		bool monitor_training_accuracy = false,
	    bool stocks = false) {
		
		
		if (!evaluation_data.empty()) { int n_data = (int)evaluation_data.size(); }
		int n = (int)training_data.size();
		std::vector<std::vector<inout>> mini_batches;
		mini_batches.reserve(n / mini_batch_size);
		int n_data;
		if (!evaluation_data.empty()) {
			n_data = evaluation_data.size();
		}
		for (int i = 0; i < epochs; ++i) {
			shuffle(training_data);
			for (int j = 0; j < n; j += mini_batch_size) {
				mini_batches.emplace_back(training_data.begin() + j,
					training_data.begin() + j + mini_batch_size);
			}
			update_mini_batches(eta, lambda, mini_batches, n);
			cout << "Epoch " << (i + 1) << " training complete\n";
			//monitor_training_accuracy = false;
			if (monitor_training_accuracy) {
				if (!stocks) {
					cout << "Training data accuracy: " << accuracy(training_data) <<
						" / " << training_data.size() << "\n";
				}
				else {
					cout << "Training data accuracy: " << stockAccuracy(training_data) << "\n";
				}
			}
			if (monitor_evaluation_accuracy) {
				if (!stocks) {
					cout << "Evaluation data accuracy: " << accuracy(evaluation_data) <<
						" / " << n_data << "\n";
				}
				else {
					cout << "Evaluation data accuracy: " << stockAccuracy(evaluation_data) << "\n";
				}
			}
			//monitor_training_cost = false;
			if (monitor_training_cost) {
				cout << "Training data cost: " << eval_cost(training_data, lambda) << "\n";
			}
			if (monitor_evaluation_cost) {
				cout << "Evaluation data cost: " << eval_cost(evaluation_data, lambda) << "\n";
			}
			cout << "\n";
			mini_batches.clear();
		}
	}

	void update_mini_batches(double &eta, double lambda, std::vector<std::vector<inout>> &mini_batches, int n) {
		int j = 0;
		for (auto && mini_batch : mini_batches) {
			nablas nabla_w_b;
			backprop(mini_batch, nabla_w_b);
			for (unsigned i = 0; i < weights.size(); ++i)
				weights[i].noalias() = (1-eta*(lambda/n))*weights[i]-(eta/(int)mini_batch.size())*nabla_w_b.first[i];
			for (unsigned i = 0; i < biases.size(); ++i)
				biases[i].noalias() = biases[i]-(eta/(int)mini_batch.size())*nabla_w_b.second[i];
			++j;
		}
		eta *= 0.98;
	}

	void backprop(std::vector<inout> &mini_batch, nablas &nabla_w_b) {
		//clock_t start = clock();
		Eigen::MatrixXd X(mini_batch[0].first.size(), mini_batch.size());
		Eigen::MatrixXd Y(mini_batch[0].second.size(), mini_batch.size());
		int Y_rows = Y.rows();
		int X_rows = X.rows();
		int Y_cols = Y.cols();
		int X_cols = X.cols();
		if (X_rows > Y_rows && X_cols > Y_cols) {
			for (int i = 0; i < Y_rows; ++i) {
				for (int j = 0; j < Y_cols; ++j) {
					swap(Y(i, j), mini_batch[j].second(i));
					swap(X(i, j), mini_batch[j].first(i));
				}
				for (int j = Y_cols; j < X_cols; ++j)
					swap(X(i, j), mini_batch[j].first(i));
			}
			for (int i = Y_rows; i < X_rows; ++i) {
				for (int j = 0; j < X_cols; ++j) {
					swap(X(i, j), mini_batch[j].first(i));
				}
			}
		}
		else if (X_rows > Y_rows && X_cols == Y_cols) {
			for (int i = 0; i < Y_rows; ++i) {
				for (int j = 0; j < X_cols; ++j) {
					swap(Y(i, j), mini_batch[j].second(i));
					swap(X(i, j), mini_batch[j].first(i));
				}
			}
			for (int i = Y_rows; i < X_rows; ++i) {
				for (int j = 0; j < X_cols; ++j) {
					swap(X(i, j), mini_batch[j].first(i));
				}
			}
		}
		else if (X_rows > Y_rows && X_cols < Y_cols) {
			for (int i = 0; i < Y_rows; ++i) {
				for (int j = 0; j < X_cols; ++j) {
					swap(Y(i, j), mini_batch[j].second(i));
					swap(X(i, j), mini_batch[j].first(i));
				}
				for (int j = X_cols; j < Y_cols; ++j) {
					swap(Y(i, j), mini_batch[j].second(i));
				}
			}
			for (int i = Y_rows; i < X_rows; ++i) {
				for (int j = 0; j < X_cols; ++j) {
					swap(X(i, j), mini_batch[j].first(i));
				}
			}
		}
		else if (X_rows < Y_rows && X_cols > Y_cols) {
			for (int i = 0; i < X_rows; ++i) {
				for (int j = 0; j < Y_cols; ++j) {
					swap(X(i, j), mini_batch[j].first(i));
					swap(Y(i, j), mini_batch[j].second(i));
				}
				for (int j = Y_cols; j < X_cols; ++j) {
					swap(X(i, j), mini_batch[j].first(i));
				}
			}
			for (int i = X_rows; i < Y_rows; ++i) {
				for (int j = 0; j < Y_cols; ++j) {
					swap(Y(i, j), mini_batch[j].second(i));
				}
			}
		}
		else if (X_rows < Y_rows && X_cols == Y_cols) {
			for (int i = 0; i < X_rows; ++i) {
				for (int j = 0; j < X_cols; ++j) {
					swap(X(i, j), mini_batch[j].first(i));
					swap(Y(i, j), mini_batch[j].second(i));
				}
			}
			for (int i = X_rows; i < Y_rows; ++i) {
				for (int j = 0; j < Y_cols; ++j) {
					swap(Y(i, j), mini_batch[j].second(i));
				}
			}
		}
		else {
			for (int i = 0; i < X_rows; ++i) {
				for (int j = 0; j < X_cols; ++j) {
					swap(X(i, j), mini_batch[j].first(i));
					swap(Y(i, j), mini_batch[j].second(i));
				}
				for (int j = X_cols; j < Y_cols; ++j) {
					swap(Y(i, j), mini_batch[j].second(i));
				}
			}
			for (int i = X_rows; i < Y_rows; ++i) {
				for (int j = 0; j < Y_cols; ++j) {
					swap(Y(i, j), mini_batch[j].second(i));
				}
			}
		}
		unsigned w_size = weights.size();
		std::vector<Eigen::MatrixXd> activations(w_size + 1);
		activations[0] = X;
		std::vector<Eigen::MatrixXd> zs(w_size);
		nabla_w_b.first.resize(w_size);
		nabla_w_b.second.resize(w_size);

		for (unsigned i = 0; i < w_size; ++i) {
			zs[i] = weights[i] * activations[i];
			zs[i].noalias() += dup_cols(biases[i], activations[i].cols());
			activations[i + 1] = sigmoid(zs[i]);
		}

		Eigen::MatrixXd delta = cost.delta(zs[zs.size() - 1], activations[activations.size() - 1], Y);
		//cout << delta << endl;
		nabla_w_b.second[nabla_w_b.second.size() - 1] = delta * Eigen::MatrixXd::Ones(delta.cols(), 1);
		nabla_w_b.first[nabla_w_b.first.size() - 1] = delta * activations[activations.size() - 2].transpose();

		for (int l = 2; l < num_layers; ++l) {
			delta = hadamard_prod(((weights[weights.size() - l + 1]).transpose() * delta), sigmoid_prime(zs[zs.size() - l]));
			nabla_w_b.first[nabla_w_b.first.size() - l] = delta * activations[activations.size() - l - 1].transpose();
			nabla_w_b.second[nabla_w_b.second.size() - l] = delta * Eigen::MatrixXd::Ones(delta.cols(), 1);
		}
	}

	int accuracy(std::vector<inout> &data) {
		std::vector<std::pair<int, int>> results(data.size());
		for (unsigned i = 0; i < data.size(); ++i) {
			results[i] = { argmax(feedforward(data[i].first)), argmax(data[i].second) };
		}
		int total = 0;
		for (unsigned i = 0; i < results.size(); ++i) {
			total += (results[i].first == results[i].second);
		}
		return total;
	}

	double stockAccuracy(std::vector<inout> &data) {
		std::vector<std::pair<Eigen::VectorXd, Eigen::VectorXd>> results(data.size());
		for (unsigned i = 0; i < data.size(); i++) {
			//cout << data[i].first << ", " << data[i].second << endl;
			results[i] = { feedforward(data[i].first), data[i].second };
			//cout << results[i].first << ", " << results[i].second << endl;
		}
		//cout << endl;
		double error = 0.0;
		for (unsigned i = 0; i < results.size(); i++) {
			for (int j = 0; j < results[i].first.size(); j++)
				//total += ((results[i].first(j, 0) > 0 && results[i].second(j, 0) > 0) ||
						  //(results[i].first(j, 0) < 0 && results[i].second(j, 0) < 0));
				error += std::pow((results[i].first(j, 0) - results[i].second(j, 0)), 2);
		}
		error /= (double)results.size();
		return error;
	}

	double eval_cost(const std::vector<inout> &data, double lambda) {
		double total_cost = 0.0;
		for (unsigned i = 0; i < data.size(); ++i) {
			Eigen::MatrixXd a = feedforward(data[i].first);
			total_cost += cost.fn(a, data[i].second) / (int)data.size();
		}
		double sum = 0;
		for (int i = 0; i < (int)weights.size(); ++i) {
			sum += std::pow(norm(weights[i]), 2);
		}
		total_cost += 0.5 * (lambda / (int)data.size()) * sum;
		return total_cost;
	}

	void input(std::string file) {
		std::ifstream infile;
		infile.open(file);
		infile >> num_layers;
		int rows, cols;
		for (int i = 0; i < num_layers - 1; i++) {
			infile >> rows >> cols;
			for (int j = 0; j < rows; j++) {
				for (int k = 0; k < cols; k++) {
					infile >> weights[i](j, k);
				}
			}
		}
		for (int i = 0; i < num_layers - 1; i++) {
			infile >> rows >> cols;
			for (int j = 0; j < rows; j++) {
				infile >> biases[i](j, 0);
			}
		}
	}

	void output(std::string file) {
		std::ofstream outfile;
		outfile.open(file);
		outfile << num_layers << "\n";
		for (int i = 0; i < (int)weights.size(); i++) {
			outfile << weights[i].rows() << " " << weights[i].cols() << "\n";
			outfile << weights[i] << "\n";
		}
		for (int i = 0; i < (int)biases.size(); i++) {
			outfile << biases[i].rows() << " " << biases[i].cols() << "\n";
			outfile << biases[i] << "\n";
		}
		outfile.close();
	}

private:
	std::vector<int> layers;
	std::vector<Eigen::MatrixXd> weights;
	std::vector<Eigen::MatrixXd> biases;
	Cost cost;
	OutType ot;
	int num_layers;
};

template <typename T>
void shuffle(std::vector<T> &vec) {
	srand((unsigned)time(NULL));
	for (unsigned i = 0; i < vec.size(); ++i) {
		int rand_i = rand() % ((int)vec.size() - i);
		//vec.push_back(vec[rand_i]);
		swap(vec[i], vec[rand_i]);
	}
}

int argmax(std::vector<double> args) {
	double max_val = 0.0;
	int max_index = 0;
	for (unsigned i = 0; i < args.size(); ++i) {
		if (max_val < args[i]) {
			max_val = args[i];
			max_index = i;
		}
	}
	return max_index;
}

int argmax(Eigen::VectorXd args) {
	assert(args.cols() == 1);
	double max_val = 0.0;
	double val;
	int max_index = 0;
	for (int i = 0; i < args.rows(); ++i) {
		val = args(i, 0);
		if (max_val < args(i, 0)) {
			max_val = args(i, 0);
			max_index = i;
		}
	}

	return max_index;
}

Eigen::MatrixXd dup_cols(const Eigen::VectorXd &mat, int num) {
	Eigen::MatrixXd result(mat.rows(), num);
	for (int i = 1; i < num; ++i) {
		for (int j = 0; j < mat.rows(); ++j) {
			result(j, i) = mat(j);
		}
	}
	return result;
}

Eigen::MatrixXd hadamard_prod(Eigen::MatrixXd mat1, const Eigen::MatrixXd &mat2) {
	assert(mat1.rows() == mat2.rows());
	assert(mat1.cols() == mat2.cols());
	int rows = mat1.rows(), cols = mat1.cols();
	//Eigen::MatrixXd result(rows, cols);
	for (int i = 0; i < rows; ++i) {
		for (int j = 0; j < cols; ++j) {
			mat1(i, j) *= mat2(i, j);
		}
	}
	return mat1;
}
#endif