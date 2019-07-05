#!/bin/bash -ex

cd /opt/rapids

###
# Build librmm
###
mkdir -p ${RMM_HOME}/build && cd ${RMM_HOME}/build \
 && cmake .. -DBUILD_TESTS=${BUILD_TESTS:-OFF} \
             -DCMAKE_INSTALL_PREFIX=${RMM_ROOT} \
             -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE:-Release} \
 && make install -j \
 && make rmm_python_cffi

###
# Build custrings
###
mkdir -p ${CUSTRINGS_HOME}/cpp/build && cd ${CUSTRINGS_HOME}/cpp/build \
 && cmake .. -DBUILD_TESTS=${BUILD_TESTS:-OFF} \
             -DCMAKE_INSTALL_PREFIX=${CUSTRINGS_ROOT} \
             -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE:-Release} \
 && make install -j

cd ${CUSTRINGS_HOME}/python && python setup.py install

###
# Build libcudf and cuDF
###
mkdir -p ${CUDF_HOME}/cpp/build && cd ${CUDF_HOME}/cpp/build \
 && cmake .. -DBUILD_TESTS=${BUILD_TESTS:-OFF} \
             -DCMAKE_INSTALL_PREFIX=${CUDF_ROOT} \
             -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE:-Release} \
 && make install -j

cd ${CUDF_HOME}/python/cudf && python setup.py build_ext --inplace
cd ${CUDF_HOME}/python/dask_cudf && python setup.py build_ext --inplace

# Build libcugraph and cuGraph
mkdir -p ${CUGRAPH_HOME}/cpp/build && cd ${CUGRAPH_HOME}/cpp/build \
 && cmake .. -DBUILD_TESTS=${BUILD_TESTS:-OFF} \
             -DCMAKE_INSTALL_PREFIX=${CUGRAPH_ROOT} \
             -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE:-Release} \
 && make install -j

cd ${CUGRAPH_HOME}/python && python setup.py build_ext --inplace

chown -R ${_UID}:${_GID} $RMM_HOME $CUDF_HOME $CUGRAPH_HOME $CUSTRINGS_HOME