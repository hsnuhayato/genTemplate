#!/bin/sh
. ./config.sh

/usr/bin/rtc-template -bcxx \
    --module-name=${COMP_NAME} \
    --module-type='wuTestComponent' \
    --module-desc='wuTestComponent' \
    --module-version=1.0 \
    --module-vendor='tohoku' \
    --module-category=example \
    --module-comp-type=DataFlowComponent \
    --module-act-type=SPORADIC \
    --module-max-inst=1 \
    --inport=q:TimedDoubleSeq \
    --inport=qRefIn:TimedDoubleSeq \
    --inport=forceR:TimedDoubleSeq \
    --inport=forceL:TimedDoubleSeq \
    --inport=rate:TimedDoubleSeq \
    --inport=acc:TimedDoubleSeq \
    --inport=rpy:TimedDoubleSeq \
    --inport=zmpRef:TimedDoubleSeq \
    --inport=rpyRef:TimedDoubleSeq \
    --outport=qRefOut:TimedDoubleSeq \
    --outport=refq:TimedDoubleSeq \
    --service=${COMP_NAME}Service:service0:${COMP_NAME}Service \
    --service-idl=${COMP_NAME}Service.idl \

rm *_vc*
rm *.bat
rm user_config.vsprops
mv ${COMP_NAME}ServiceSVC_impl.h ${COMP_NAME}Service_impl.h
mv ${COMP_NAME}ServiceSVC_impl.cpp ${COMP_NAME}Service_impl.cpp
rm Makefile.${COMP_NAME}

removeSVC() {
    sed -e "s/ServiceSVC/Service/g" $1 > /tmp/.$1
    sed -e "s/SERVICESVC/SERVICE/g" /tmp/.$1 > $1
}

removeSVC ${COMP_NAME}.h
removeSVC ${COMP_NAME}Service_impl.h
removeSVC ${COMP_NAME}Service_impl.cpp

removeOpenHRP() {
    sed -e "s/OpenHRP_//g" $1 > /tmp/.$1
    sed -e "s/${COMP_NAME}ServiceSkel.h/${COMP_NAME}Service.hh/g" /tmp/.$1 > $1
}
removeOpenHRP ${COMP_NAME}Service_impl.h
removeOpenHRP ${COMP_NAME}Service_impl.cpp

