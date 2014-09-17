#!/usr/bin/env python

import threading
import multiprocessing
import time

class WorkerA(multiprocessing.Process):
    def __init__(self, task):
        self.task = task
        super(WorkerA, self).__init__()
    def run(self):
        while True:
            print self.task
            time.sleep(1)

class WorkerB(multiprocessing.Process):
    def __init__(self, task):
        self.task = task
        super(WorkerB, self).__init__()
    def run(self):
        while True:
            print self.task
            time.sleep(1)

if __name__ == '__main__':
    A=WorkerA('This is Worker A')
    A.start()
    B=WorkerB('This is Worker B')
    B.start()
    while True:
        time.sleep(10)
