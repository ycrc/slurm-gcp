# Slurm on Google Cloud Platform

#### This repository is no longer actively developed

6.3.1 is the last release on this repository. Active development will continue
here:

https://github.com/GoogleCloudPlatform/slurm-gcp

[Google HPC-Toolkit](https://github.com/GoogleCloudPlatform/hpc-toolkit) is the
recommended way to use Slurm in GCP.

______________________________________________________________________

[FAQ](./docs/faq.md) | [Troubleshooting](./docs/troubleshooting.md) |
[Glossary](./docs/glossary.md)

<!-- mdformat-toc start --slug=github --no-anchors --maxlevel=3 --minlevel=2 -->

- [Overview](#overview)
- [Image Support](#image-support)
  - [SchedMD](#schedmd)
- [Cluster Configurations](#cluster-configurations)
  - [Cloud](#cloud)
  - [Hybrid](#hybrid)
  - [Multi-Cluster/Federation](#multi-clusterfederation)
- [Upgrade to v6](#upgrade-to-v6)
- [TPU support](#tpu-support)
- [Help and Support](#help-and-support)

<!-- mdformat-toc end -->

## Overview

`slurm-gcp` is an open-source software solution that enables setting up
[Slurm clusters](./docs/glossary.md#slurm) on
[Google Cloud Platform](./docs/glossary.md#gcp) with ease. With it, you can
create and manage [Slurm](./docs/glossary.md#slurm) cluster infrastructure in
[GCP](./docs/glossary.md#gcp), deployed in different configurations.

Google's
[HPC Toolkit](https://cloud.google.com/blog/products/compute/new-google-cloud-hpc-toolkit),
on [github](https://github.com/GoogleCloudPlatform/hpc-toolkit), can be used to
manage and deploy [Slurm clusters](./docs/glossary.md#slurm) and other
supporting infrastrucutre via
[HPC Blueprints](https://cloud.google.com/hpc-toolkit/docs/setup/hpc-blueprint).

## Image Support

See [supported Operating Systems](./docs/images.md#supported-operating-systems)
and [published Image Family](./docs/images.md#published-image-family) for
machine image support.

### SchedMD

SchedMD provides
[professional services and commercial support](https://www.schedmd.com/support.php)
to help you get up and running and stay running.

Issues and/or enhancement requests can be submitted to
[SchedMD's Bugzilla](https://bugs.schedmd.com).

Also, join community discussions on either the
[Slurm User mailing list](https://slurm.schedmd.com/mail.html) or the
[Google Cloud & Slurm Community Discussion Group](https://groups.google.com/forum/#!forum/google-cloud-slurm-discuss).

## Cluster Configurations

`slurm-gcp` can be deployed and used in different configurations and methods to
meet your computing needs.

See
[HPC Blueprints](https://cloud.google.com/hpc-toolkit/docs/setup/hpc-blueprint)
for
[HPC Toolkit](https://cloud.google.com/blog/products/compute/new-google-cloud-hpc-toolkit)
example cluster configurations that are production ready.

### Cloud

All Slurm cluster resources will exist in the cloud.

See the [Cloud Cluster Guide](./docs/cloud.md) for details.

### Hybrid

Only Slurm compute nodes will exist in the cloud. The Slurm controller and other
Slurm components will remain in the onprem environment.

See the [Hybrid Cluster Guide](./docs/hybrid.md) for details.

### Multi-Cluster/Federation

Two or more clusters are connected, allowing for jobs to be submitted from and
ran on different clusters. This can be a mix between onprem and cloud clusters.

See the [Federated Cluster Guide](./docs/federation.md) for details.

## Upgrade to v6

See the [Upgrade to v6 Guide](./docs/upgrade_to_v6.md) for details.

## TPU support

slurm-gcp supports using TPU-vm nodes. See [TPU guide](./docs/tpu.md) for
details.

## Help and Support

- See the [slurm-gcp FAQ](./docs/faq.md) for help with `slurm-gcp`.
- See the [Slurm FAQ](https://slurm.schedmd.com/faq.html) for help with
  [Slurm](./docs/glossary.md#slurm).

Please reach out to us
[here](./docs/faq.md#how-do-i-get-support-for-slurm-gcp-and-slurm). We will be
happy to support you!
