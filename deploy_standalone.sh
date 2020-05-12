#!/usr/bin/bash
set -x

time sudo openstack tripleo deploy \
  --templates \
  --local-ip=IP/24 \
  -e /usr/share/openstack-tripleo-heat-templates/environments/standalone/standalone-tripleo.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/low-memory-usage.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/disable-telemetry.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/disable-swift.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/services/octavia.yaml \
  -r /usr/share/openstack-tripleo-heat-templates/roles/Standalone.yaml \
  -e $HOME/containers-prepare-parameters.yaml \
  -e $HOME/standalone_parameters.yaml \
  --output-dir $HOME \
  --standalone
  #-e /usr/share/openstack-tripleo-heat-templates/environments/enable-designate.yaml \
  #-e /usr/share/openstack-tripleo-heat-templates/environments/designate-config.yaml \
