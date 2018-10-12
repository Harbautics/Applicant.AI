#include <iostream>
#include "Network.h"
#include "Load_data.h"

#define TRAIN_SIZE 1000
#define TEST_SIZE 100

//#define IMG_SIZE 784
//#define LBL_SIZE 10

#define DATA_SIZE 18
#define LBL_SIZE 2

using namespace std;

int main() {
	/*vector<Eigen::SparseMatrix<double>> train_img, train_lbl;
	vector<Eigen::SparseMatrix<double>> test_img, test_lbl;
	vector<inout> training;
	vector<inout> testing;
	
	ReadMNIST("C:\\Users\\Collin\\Documents\\Visual Studio 2015\\Projects\\Network\\train-images.idx3-ubyte",
			  "C:\\Users\\Collin\\Documents\\Visual Studio 2015\\Projects\\Network\\train-labels.idx1-ubyte",
			  TRAIN_SIZE, IMG_SIZE, train_img, train_lbl);
	ReadMNIST("C:\\Users\\Collin\\Documents\\Visual Studio 2015\\Projects\\Network\\t10k-images.idx3-ubyte",
			  "C:\\Users\\Collin\\Documents\\Visual Studio 2015\\Projects\\Network\\t10k-labels.idx1-ubyte",
			  TEST_SIZE, IMG_SIZE, test_img, test_lbl);*/
	vector<Eigen::SparseMatrix<double>> train_data, train_lbl;
	vector<Eigen::SparseMatrix<double>> test_data, test_lbl;
	vector<inout> training;
	vector<inout> testing;

	string train_data_file = "", train_label_file = "";
	string test_data_file = "", test_label_file = "";

	load_data(train_data_file,
			  train_label_file,
			  TRAIN_SIZE, DATA_SIZE, train_data, train_lbl);
	load_data(test_data_file,
			  test_label_file,
			  TEST_SIZE, DATA_SIZE, test_data, test_lbl);

	pair<Eigen::MatrixXd, Eigen::MatrixXd> train;
	pair<Eigen::MatrixXd, Eigen::MatrixXd> test;
	for (unsigned i = 0; i < TEST_SIZE; ++i) {
		train_data[i].makeCompressed();
		train_lbl[i].makeCompressed();
		test_data[i].makeCompressed();
		test_lbl[i].makeCompressed();
		//cout << train_lbl[i] << endl;
		train = make_pair(move(train_data[i]), move(train_lbl[i]));
		test = make_pair(move(test_data[i]), move(test_lbl[i]));
		training.emplace_back(move(train));
		testing.emplace_back(move(test));
	}
	test_data.clear();
	test_lbl.clear();
	//cout << endl;
	for (unsigned i = TEST_SIZE; i < TRAIN_SIZE; ++i) {
		train = make_pair(move(train_data[i]), move(train_lbl[i]));
		training.emplace_back(move(train));
	}
	cout << "Beginning training\n";
	train_data.clear();
	string outfile = "trainedNet.txt";
	train_lbl.clear();
	vector<int> layers = { 784,30,10 };
	CrossEntropy cost;
	Classify ot;
	Network<CrossEntropy, Classify> net(layers, cost, ot);
	net.SGD(training, 30, 100, 0.1, 1.0, testing, true, true, true, true, false);
	net.output(outfile);
	cout << endl;
	return 0;
}