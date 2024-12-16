#include <iostream>
#include <fstream>
#include <pthread.h>
#include <vector>
#include <cstdlib>
#include <ctime>
#include <unistd.h> // для функции sleep
#include <cstring>

struct Phone {
    pthread_rwlock_t rwlock; // RWLock для телефона
    bool is_busy;           // Состояние телефона
};


std::vector<Phone> phones;
int N;
bool stop_simulation = false; // Флаг для завершения симуляции
pthread_mutex_t console_mutex = PTHREAD_MUTEX_INITIALIZER; // Мьютекс для синхронизации вывода в консоль
std::ofstream output_file; // Файл для записи результатов

// Функция для синхронизированного вывода
void synchronized_output(const std::string& message) {
    pthread_mutex_lock(&console_mutex);
    std::cout << message << "\n";
    if (output_file.is_open()) {
        output_file << message << "\n";
    }
    pthread_mutex_unlock(&console_mutex);
}

// Функция, моделирующая поведение болтуна
void* chatter_behavior(void* arg) {
    int id = *(int*)arg;
    srand(time(nullptr) + id); // Инициализация генератора случайных чисел

    while (!stop_simulation) {
        // Случайно выбрать режим: ожидание или звонок
        bool action_chosen = false;
        int target;
        while (!action_chosen) {
            if (rand() % 2 == 0) {
                // Ждать звонка
                pthread_rwlock_rdlock(&phones[id].rwlock);
                if (!phones[id].is_busy) {
                    synchronized_output("Chatter " + std::to_string(id) + " is waiting for a call.");
                    pthread_rwlock_unlock(&phones[id].rwlock);
                    sleep(rand() % 3 + 1); // Ждать случайное время (1-3 секунды)
                    action_chosen = true;
                } else {
                    pthread_rwlock_unlock(&phones[id].rwlock);
                }
            } else {
                // Совершить звонок
                while (true) {
                    target = rand() % N;
                    if (target == id) continue; // Не звонить самому себе

                    // Попробовать заблокировать оба телефона
                    if (pthread_rwlock_wrlock(&phones[id].rwlock) == 0) {
                        if (pthread_rwlock_wrlock(&phones[target].rwlock) == 0) {
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
                                pthread_rwlock_unlock(&phones[target].rwlock);
                                pthread_rwlock_unlock(&phones[id].rwlock);
                                action_chosen = true;
                                break;
                            } else {
                                // Телефоны заняты, освободить RWLock
                                pthread_rwlock_unlock(&phones[target].rwlock);
                                pthread_rwlock_unlock(&phones[id].rwlock);
                            }
                        } else {
                            pthread_rwlock_unlock(&phones[id].rwlock);
                        }
                    }
                }
            }
        }
    }

    return nullptr;
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
            std::cerr << "The number of chatters must be greater than 1.\n";
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

    // Инициализация телефонов
    phones.resize(N);
    for (int i = 0; i < N; ++i) {
        pthread_rwlock_init(&phones[i].rwlock, nullptr);
        phones[i].is_busy = false;
    }

    // Создание потоков для болтунов
    std::vector<pthread_t> threads(N);
    std::vector<int> ids(N);
    for (int i = 0; i < N; ++i) {
        ids[i] = i;
        if (pthread_create(&threads[i], nullptr, chatter_behavior, &ids[i]) != 0) {
            std::cerr << "Error creating thread " << i << "\n";
            return 1;
        }
    }

    // Ожидание завершения симуляции
    synchronized_output("Press Enter to stop the simulation...");
    std::cin.get();
    stop_simulation = true;

    // Ожидание завершения потоков
    for (int i = 0; i < N; ++i) {
        pthread_join(threads[i], nullptr);
    }

    // Очистка ресурсов
    for (int i = 0; i < N; ++i) {
        pthread_rwlock_destroy(&phones[i].rwlock);
    }
    pthread_mutex_destroy(&console_mutex);

    output_file.close();

    synchronized_output("Simulation ended.");
    return 0;
}
