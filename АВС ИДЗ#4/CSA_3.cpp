#include <iostream>
#include <fstream>
#include <vector>
#include <cstdlib>
#include <ctime>
#include <unistd.h> // Для функции sleep
#include <omp.h>

struct Phone {
    omp_lock_t lock; // Замок для телефона
    bool is_busy;    // Состояние телефона
};

std::vector<Phone> phones;
int N;
bool stop_simulation = false; // Флаг для завершения симуляции
std::ofstream output_file;   // Файл для записи результатов

// Функция для синхронизированного вывода
void synchronized_output(const std::string& message) {
    #pragma omp critical
    {
        std::cout << message << "\n";
        if (output_file.is_open()) {
            output_file << message << "\n";
        }
    }
}

// Функция, моделирующая поведение болтуна
void chatter_behavior(int id) {
    srand(time(nullptr) + id); // Инициализация генератора случайных чисел

    while (!stop_simulation) {
        bool action_chosen = false;
        int target;
        while (!action_chosen) {
            if (rand() % 2 == 0) {
                // Ждать звонка
                omp_set_lock(&phones[id].lock);
                if (!phones[id].is_busy) {
                    synchronized_output("Chatter " + std::to_string(id) + " is waiting for a call.");
                    omp_unset_lock(&phones[id].lock);
                    sleep(rand() % 3 + 1); // Ждать случайное время (1-3 секунды)
                    action_chosen = true;
                } else {
                    omp_unset_lock(&phones[id].lock);
                }
            } else {
                // Совершить звонок
                while (true) {
                    target = rand() % N;
                    if (target == id) continue; // Не звонить самому себе

                    if (omp_test_lock(&phones[id].lock)) {
                        if (omp_test_lock(&phones[target].lock)) {
                            if (!phones[target].is_busy && !phones[id].is_busy) {
                                // Оба телефона свободны, начать разговор
                                phones[id].is_busy = true;
                                phones[target].is_busy = true;

                                synchronized_output("Chatter " + std::to_string(id) + " is talking to Chatter " + std::to_string(target) + ".");

                                sleep(rand() % 3 + 1); // Разговор длится 1-3 секунды

                                // Закончить разговор
                                synchronized_output("Chatter " + std::to_string(id) + " has finished talking to Chatter " + std::to_string(target) + ".");

                                phones[id].is_busy = false;
                                phones[target].is_busy = false;
                                omp_unset_lock(&phones[target].lock);
                                omp_unset_lock(&phones[id].lock);
                                action_chosen = true;
                                break;
                            } else {
                                // Телефоны заняты, освободить замки
                                omp_unset_lock(&phones[target].lock);
                                omp_unset_lock(&phones[id].lock);
                            }
                        } else {
                            omp_unset_lock(&phones[id].lock);
                        }
                    }
                }
            }
        }
    }
}

int main(int argc, char* argv[]) {
    std::string config_file;
    std::string output_filename;
    if (argc == 4 && strcmp(argv[1], "-n") == 0) {
        N = atoi(argv[2]);
        output_filename = argv[3];
        if (N <= 1) {
            std::cerr << "The number of chatters must be greater than 1.\n";
            return 1;
        }
    } else if (argc == 4 && strcmp(argv[1], "-c") == 0) {
        config_file = argv[2];
        output_filename = argv[3];
        std::ifstream config(config_file);
        if (!config.is_open()) {
            std::cerr << "Could not open configuration file: " << config_file << "\n";
            return 1;
        }
        config >> N;
        config.close();
        if (N <= 1) {
            std::cerr << "The number of chatters must be greater than 1." << "\n";
            return 1;
        }
    } else {
        std::cerr << "Usage: " << argv[0] << " -n <number_of_chatters> <output_file>\n"
                  << "       " << argv[0] << " -c <config_file> <output_file>\n";
        return 1;
    }

    // Открытие файла для вывода
    output_file.open(output_filename);
    if (!output_file.is_open()) {
        std::cerr << "Could not open output file: " << output_filename << "\n";
        return 1;
    }

    synchronized_output("Press Enter to stop the simulation...");

    // Инициализация телефонов
    phones.resize(N);
    for (int i = 0; i < N; ++i) {
        omp_init_lock(&phones[i].lock);
        phones[i].is_busy = false;
    }

    // Создание потоков для болтунов
    #pragma omp parallel num_threads(N)
    {
        int id = omp_get_thread_num();
        chatter_behavior(id);
    }

    // Ожидание завершения симуляции
    std::cin.get();
    stop_simulation = true;

    // Очистка ресурсов
    for (int i = 0; i < N; ++i) {
        omp_destroy_lock(&phones[i].lock);
    }

    output_file.close();

    synchronized_output("Simulation ended.");
    return 0;
}
