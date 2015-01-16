#!/opt/grx/bin/hrpsyspy
import os

import sys
import socket
import traceback
import math
import time
import java.lang.System

import rtm
import waitInput
import OpenHRP
from OpenHRP.RobotHardwareServicePackage import SwitchStatus

def init(robotHost=None):
    if robotHost != None:
      print 'robot host = '+robotHost
      java.lang.System.setProperty('NS_OPT',
          '-ORBInitRef NameService=corbaloc:iiop:'+robotHost+':2809/NameService')
      rtm.initCORBA()

    print "creating components"
    rtcList = createComps(robotHost)

   
def activateComps(rtcList):
    rtm.serializeComponents(rtcList)
    for r in rtcList:
        r.start()

def initRTC(module, name):
    ms.load(module)
    return ms.create(module, name)

def createComps(hostname=socket.gethostname()):
    global ms, user, user_svc, log, rh, servo
    ms = rtm.findRTCmanager(hostname)
    
    user = rtm.findRTC("wuTest0")
    if user==None:
        print "no user component"
        return

    user_svc = OpenHRP.wuTestServiceHelper.narrow(user.service("service0"))
    if user_svc==None:
        print "no svc"
    
    user.start()

#def connectComps():
#    rtm.connectPorts(user.port("refq"),    servo.port("qRefIn"))
    
    

##########
#grxuer method

def start():
    user_svc.start()

def setObjectV(x):
    itemlist = x.split() #import numpy 
    numbers = [ float(item) for item in itemlist ]
    print "wa= ",numbers[0]+numbers[2]
    user_svc.setObjectV(numbers[0], numbers[1], numbers[2], numbers[3], numbers[4], numbers[5])

def testMove():
    user_svc.testMove()

###########

