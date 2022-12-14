# SAS-SPIN-DOWN

Reduce disk drive spin down through sg3utils to save power!

## Summary

**sas-spin-down.sh** is a rather simple Bash script that enables automatic disk
standby for SAS drives.
(e.g. `sdparm`).

## Usage, Requirements
- `sg3-utils`
- `smartmontools`

### set-spin-down.sh
This Base script only needs to be executed once,
and then all configurations will be saved to the SAS disk drive(If it's supported, normally).

the following is required:
**sdparm** for actually initiating drive standby

### scan-status.sh

This script can be used to view the BMS(background scan) status of all SAS hard disks.

the following is required:
**smartctl:** for detection of drive status and SMART self-checks

If the disk is running, the following information would be output:


### standby-status.sh

This script can be used to view the status of all SAS hard disks.
If the disk is running, the following information would be output:

`HITACHI C370 HUS72403CLAR3000 /dev/sg0  /dev/sda active`

If the disk is standby(spun down), the following information would be output:

`HITACHI C1D8 HUS72303CLAR3000 /dev/sg0  /dev/sda standby`

As you see, idle mode (e.g. `idle_a`,`idle_b`,`idle_c`) will be merged into active display

the following is required:
**sdparm** for actually initiating drive standby

## Configuration

**set-spin-down.sh** uses a simple shell-style configuration file for setting
the disks to monitor. An example may look like this:

    # configuration for sas-spin-down.sh
    IDLEA=1  #idle_a
    IDLEA_TIME=20
    IDLEB=1  #idle_b
    IDLEB_TIME=6000
    IDLEC=1  #idle_c
    IDLEC_TIME=9000
    STANDBY=1  #standby_z
    STANDBY_TIME=12000

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