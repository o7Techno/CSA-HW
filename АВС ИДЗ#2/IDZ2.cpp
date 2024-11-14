#include <iostream>
#include <cmath>
#include <vector>

int main() {
    std::vector<double> arr = {2, 3, 4, 5, 6, 10, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 30000, 40000};
    for (size_t i = 0; i < arr.size(); ++i) {
        double sum = 0;
        for (double n = 1; n < arr[i]; ++n) {
            sum += 1 / n / n;
        }
        std::cout << std::sqrt(sum * 6) << "\n";
    }
    return 0;
}