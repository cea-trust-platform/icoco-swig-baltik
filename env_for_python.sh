#!/bin/bash
# Swig_Baltik python tools initialization script

err=0
# check if Swig_Baltik env is sourced. Otherwise source it !
if [ ! -d "${project_directory}" ]; then
  DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
  source $DIR/env_SWIG_BALTIK.sh || err=1
fi

[ $err = 1 ] && echo "Error: cannot load env_for_python.sh. Swig_Baltik not yet installed!" && return 1

# Chargement Swig_Baltik ICoCo swig
if [ "`echo $PYTHONPATH | grep -i ${project_directory}/share/swig/install/lib`" = "" ] && [ "$TRUST_DISABLE_MPI" -eq 0 ]
then
  #if [ -f $project_directory/share/swig/install/lib/_swigbaltikicoco.so ]
  #then
     export PYTHONPATH=$project_directory/share/swig/install/lib:$PYTHONPATH
  #else
  #   echo "Error: cannot load env_for_python.sh. swigbaltikicoco not yet installed!"
  #   return 1
  #fi
fi

# Chargement MEDCoupling
if [ "`echo $PYTHONPATH | grep -i LIBMEDCOUPLING/install/bin`" = "" ]
then
  if [ -f $TRUST_MEDCOUPLING_ROOT/env.sh ]
  then
     source $TRUST_MEDCOUPLING_ROOT/env.sh
  else
     echo "Error: cannot load env_for_python.sh. MEDCoupling not yet installed!"
     return 1
 fi
fi

echo "env_for_python.sh for Swig_Baltik is successfully loaded."

