## systemd, init — systemd system and service manager

### Concepts

systemd provides a dependency system between various entities called "units" of 12 different types. Units encapsulate various objects that are relevant for system boot-up and maintenance. The majority of units are configured in unit configuration files, whose syntax and basic set of options is described in systemd.unit(5), however some are created automatically from other configuration, dynamically from system state or programmatically at runtime.

Units may be "active" (meaning started, bound, plugged in, ..., depending on the unit type, see below), or "inactive" (meaning stopped, unbound, unplugged, ...), as well as in the process of being activated or deactivated, i.e. between the two states (these states are called "activating", "deactivating"). A special "failed" state is available as well, which is very similar to "inactive" and is entered when the service failed in some way (process returned error code on exit, or crashed, or an operation timed out). If this state is entered, the cause will be logged, for later reference.

Note that the various unit types may have a number of additional substates, which are mapped to the five generalized unit states described here.

`/usr/lib/systemd/systemd`

// list running service
`systemctl`

// list service with different statueses
```
systemctl list-units -all --state=inactive
systemctl list-units -all --state=failed

active
inactive
activating
deactivating
failed

not-found
dead

```


// check service status and detail
`systemctl status service-name`

// service directory
`/usr/lib/systemd/system/service-name`

// enable service
```
systemctl enable service-name
systemctl enable service-name
systemctl restart service-name
```