#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import subprocess as sbp
import multiprocessing
import argparse
import sys
import os

BASE_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), '../../..')

def argparser(argv):
    parser = argparse.ArgumentParser(description='VINS-Fusion Docker')
    parser.add_argument('-a', '--arch', type=str, help='platform arch')
    parser.add_argument('--vins', action='store_true', help='launch vins')
    parser.add_argument('--bridge', action='store_true', help='launch ros1_bridge')
    parser.add_argument('--ego', action='store_true', help='launch ego_planner')
    parser.add_argument('--demo', action='store_true', help='run demo')
    parser.add_argument('--d435i', action='store_true', help='run with d435i')
    args = parser.parse_args(argv)
    return args

def run_vins(args):
    CMD = 'bash -c \"%s/ros2/src/VINS-Fusion/docker/%s/run-cpu-%s.sh\"' % (BASE_DIR, args.arch, args.arch)
    os.system(CMD)

def run_ego_planner(args):
    CMD = 'bash -c \"%s/ros1/src/ego-planner-swarm/scripts/docker/%s/run-cpu-%s.sh\"' % (BASE_DIR, args.arch, args.arch)
    os.system(CMD)

def main(argv):
    args = argparser(argv)
    pool = multiprocessing.Pool(processes = 4)
    if args.vins:
        pool.apply_async(run_vins, args=[args], callback=print)
    if args.ego:
        pool.apply_async(run_ego_planner, args=[args], callback=print)
    pool.close()
    pool.join()

if __name__ == '__main__':
    main(sys.argv[1:])
