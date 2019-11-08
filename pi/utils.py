import logging
import os
import datetime

log = None

def getLog(name):
    global log
    directory = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'log')
    if not os.path.isdir(directory):
        os.mkdir(directory)

    now = datetime.datetime.now().strftime('%Y-%m-%d_%H%M%S')
    fname = os.path.join(directory, '{}_{}.log'.format(name, now))

    logging.basicConfig(format = '%(asctime)s    %(name)s    %(levelname)s: %(message)s',
                        level = logging.INFO,
                        filename = fname)

    return logging.getLogger(name)
    
