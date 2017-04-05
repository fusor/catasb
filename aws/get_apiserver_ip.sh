#!/bin/bash
oc describe pod `oc get pods | grep apiserver | awk '{print $1}'` | grep IP | awk '{print $2}'
