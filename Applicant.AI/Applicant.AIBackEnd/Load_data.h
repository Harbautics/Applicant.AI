#ifndef LOAD_MNIST_H
#define LOAD_MNIST_H

#define DATA_SIZE 784
#define LBL_SIZE 10

#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <Eigen/Sparse>
#include <Eigen/Dense>

using namespace std;
int ReverseInt(int i)
{
	unsigned char ch1, ch2, ch3, ch4;
	ch1 = i & 255;
	ch2 = (i >> 8) & 255;
	ch3 = (i >> 16) & 255;
	ch4 = (i >> 24) & 255;
	return((int)ch1 << 24) + ((int)ch2 << 16) + ((int)ch3 << 8) + ch4;
}
void load_data(string dataFile, string lblFile, int NumberOfNodes, int DataOfAnImage, 
			   vector<Eigen::SparseMatrix<double>> &data, vector<Eigen::SparseMatrix<double>> &lbl)
{
	data.resize(NumberOfNodes, Eigen::SparseVector<double>(DATA_SIZE));
	ifstream file1(dataFile, ios::binary);
	if (file1.is_open())
	{
		int magic_number = 0;
		int number_of_images = 0;
		int n_rows = 0;
		int n_cols = 0;
		file1.read((char*)&magic_number, sizeof(magic_number));
		magic_number = ReverseInt(magic_number);
		file1.read((char*)&number_of_images, sizeof(number_of_images));
		number_of_images = ReverseInt(number_of_images);
		file1.read((char*)&n_rows, sizeof(n_rows));
		n_rows = ReverseInt(n_rows);
		file1.read((char*)&n_cols, sizeof(n_cols));
		n_cols = ReverseInt(n_cols);
		if (NumberOfNodes > number_of_images) { NumberOfNodes = number_of_images; }
		for (int i = 0; i<NumberOfNodes; ++i)
		{
			for (int r = 0; r<n_rows; ++r)
			{
				for (int c = 0; c<n_cols; ++c)
				{
					unsigned char temp = 0;
					file1.read((char*)&temp, sizeof(temp));
					data[i].insert((n_rows*r) + c, 0) = (double)temp;
				}
			}
		}
	}


	lbl.resize(NumberOfNodes, Eigen::SparseVector<double>(LBL_SIZE));
	ifstream file2(lblFile, ios::binary);
	if (file2.is_open())
	{
		int magic_number = 0;
		int number_of_nodes = 0;
		int n_rows = 0;
		int n_cols = 0;
		file2.read((char*)&magic_number, sizeof(magic_number));
		magic_number = ReverseInt(magic_number);
		file2.read((char*)&number_of_nodes, sizeof(number_of_nodes));
		number_of_nodes = ReverseInt(number_of_nodes);
		if (NumberOfNodes > number_of_nodes) { NumberOfNodes = number_of_nodes; }
		for (int i = 0; i < NumberOfNodes; ++i)
		{
			unsigned char temp = 0;
			file2.read((char*)&temp, sizeof(temp));
			double label = (double)temp;
			int index = (int)temp;
			for (int j = 0; j < 10; ++j) {
				if (j == index)
					lbl[i].insert(j, 0) = 1.0;
				else
					lbl[i].insert(j, 0) = 0.0;

			}
		}
	}
}

#endif