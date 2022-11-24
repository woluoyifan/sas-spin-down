# SAS-SPIN-DOWN

Reduce disk drive spin down through sg3utils to save power!

## Summary

**sas-spin-down.sh** is a rather simple Bash script that enables automatic disk
standby for SAS drives.
(e.g. `sdparm`).

## Usage, Requirements
- `sg3-utils`
- `smartmontools`

### sas-spin-down.sh
This Base script only needs to be executed once,
and then all configurations will be saved to the SAS disk drive(If it's supported, normally).

Apart from *coreutils* the following is required:
* **smartctl:** for detection of drive status and SMART self-checks
* **sdparm** for actually initiating drive standby

### status.sh
This script can be used to view the status of all SAS hard disks.
If the disk is running, the following information would be output:

`HITACHI C370 HUS72403CLAR3000 /dev/sg0  /dev/sda active`

If the disk is standby(spun down), the following information would be output:

`HITACHI C1D8 HUS72303CLAR3000 /dev/sg0  /dev/sda standby`

As you see, idle mode (e.g. `idle_a`,`idle_b`,`idle_c`) will be merged into active display

### stool.sh
This script is a quick tool. As a simple wrapper for `sdparm`,
you can forget the complex api and parameters of `sdparm`,
just remember `-v` for view and `-s` for set.

for view (without path `/dev`)  
`stool.sh -v DRIVENAME`

example:  
`stool.sh -v sda`

for set (without path `/dev`)  
`stool.sh -s KEY VALUE DRIVENAME`

example:  
`stool.sh -s STANDBY 1 sda`

## Configuration

**sas-spin-down.sh** uses a simple shell-style configuration file for setting
the disks to monitor. An example may look like this:

    # configuration for sas-spin-down.sh
    IDLEA=1  #idle_a
    IDLEA_TIME=1200
    IDLEB=1  #idle_b
    IDLEB_TIME=2400
    IDLEC=1  #idle_c
    IDLEC_TIME=6000
    STANDBY=1  #standby_z
    STANDBY_TIME=9000

If you are interested in customizing each parameter and understanding
the specific role of different idle modes, you can participate in
the following document, which comes from Seagate.

[tp608-powerchoice-tech-provides-gb](https://www.seagate.com/files/docs/pdf/en-GB/whitepaper/tp608-powerchoice-tech-provides-gb.pdf)

Or you can look at another document, which comes from western data and
shows the difference between states.

> 4.5.3.1 Operating Mode Descriptions

[product-manual-ultrastar-dc-hc330-sata-oem-spec](https://documents.westerndigital.com/content/dam/doc-library/en_us/assets/public/western-digital/product/data-center-drives/ultrastar-dc-hc300-series/product-manual-ultrastar-dc-hc330-sata-oem-spec.pdf)

## License
This software is released under the terms of the GPL License, see file LICENSE.