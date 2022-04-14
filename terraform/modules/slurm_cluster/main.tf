/**
 * Copyright (C) SchedMD LLC.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

##########
# LOCALS #
##########

locals {
  slurm_cluster_id = random_uuid.slurm_cluster_id.result

  partition_map = { for x in var.partitions : x.partition_name => x }

  have_template = (
    var.controller_instance_config.instance_template != null
    && var.controller_instance_config.instance_template != ""
    ? true
    : false
  )
}

##########
# RANDOM #
##########

resource "random_uuid" "slurm_cluster_id" {
}

###################
# SLURM PARTITION #
###################

module "slurm_partition" {
  source = "../slurm_partition"

  for_each = local.partition_map

  slurm_cluster_name      = var.slurm_cluster_name
  partition_nodes         = each.value.partition_nodes
  enable_job_exclusive    = each.value.enable_job_exclusive
  enable_reconfigure      = var.enable_reconfigure
  enable_placement_groups = each.value.enable_placement_groups
  network_storage         = each.value.network_storage
  partition_name          = each.value.partition_name
  partition_conf          = each.value.partition_conf
  partition_d             = each.value.partition_d
  project_id              = var.project_id
  region                  = each.value.region
  slurm_cluster_id        = local.slurm_cluster_id
  subnetwork_project      = each.value.subnetwork_project
  subnetwork              = each.value.subnetwork
  zone_policy_allow       = each.value.zone_policy_allow
  zone_policy_deny        = each.value.zone_policy_deny
}

########################
# CONTROLLER: TEMPLATE #
########################

module "slurm_controller_template" {
  source = "../slurm_instance_template"

  count = var.enable_hybrid || local.have_template ? 0 : 1

  additional_disks         = var.controller_instance_config.additional_disks
  can_ip_forward           = var.controller_instance_config.can_ip_forward
  slurm_cluster_name       = var.slurm_cluster_name
  disable_smt              = var.controller_instance_config.disable_smt
  disk_auto_delete         = var.controller_instance_config.disk_auto_delete
  disk_labels              = var.controller_instance_config.disk_labels
  disk_size_gb             = var.controller_instance_config.disk_size_gb
  disk_type                = var.controller_instance_config.disk_type
  enable_confidential_vm   = var.controller_instance_config.enable_confidential_vm
  enable_oslogin           = var.controller_instance_config.enable_oslogin
  enable_shielded_vm       = var.controller_instance_config.enable_shielded_vm
  gpu                      = var.controller_instance_config.gpu
  labels                   = var.controller_instance_config.labels
  machine_type             = var.controller_instance_config.machine_type
  metadata                 = var.controller_instance_config.metadata
  min_cpu_platform         = var.controller_instance_config.min_cpu_platform
  network_ip               = var.controller_instance_config.network_ip != null ? var.controller_instance_config.network_ip : ""
  on_host_maintenance      = var.controller_instance_config.on_host_maintenance
  preemptible              = var.controller_instance_config.preemptible
  project_id               = var.project_id
  region                   = var.controller_instance_config.region
  service_account          = var.controller_instance_config.service_account
  shielded_instance_config = var.controller_instance_config.shielded_instance_config
  slurm_cluster_id         = local.slurm_cluster_id
  slurm_instance_role      = "controller"
  source_image_family      = var.controller_instance_config.source_image_family
  source_image_project     = var.controller_instance_config.source_image_project
  source_image             = var.controller_instance_config.source_image
  subnetwork_project       = var.controller_instance_config.subnetwork_project
  subnetwork               = var.controller_instance_config.subnetwork
  tags                     = concat([var.slurm_cluster_name], var.controller_instance_config.tags)
}

########################
# CONTROLLER: INSTANCE #
########################

module "slurm_controller_instance" {
  source = "../slurm_controller_instance"

  count = var.enable_hybrid ? 0 : 1

  access_config      = var.controller_instance_config.access_config
  slurm_cluster_name = var.slurm_cluster_name
  instance_template  = local.have_template ? var.controller_instance_config.instance_template : module.slurm_controller_template[0].self_link
  project_id         = var.project_id
  region             = var.controller_instance_config.region
  slurm_cluster_id   = local.slurm_cluster_id
  static_ips         = var.controller_instance_config.static_ip != null ? [var.controller_instance_config.static_ip] : []
  subnetwork         = var.controller_instance_config.subnetwork
  zone               = var.controller_instance_config.zone

  cgroup_conf_tpl              = var.cgroup_conf_tpl
  cloud_parameters             = var.cloud_parameters
  cloudsql                     = var.cloudsql
  controller_d                 = var.controller_d
  compute_d                    = var.compute_d
  enable_devel                 = var.enable_devel
  enable_bigquery_load         = var.enable_bigquery_load
  enable_cleanup_compute       = var.enable_cleanup_compute
  enable_cleanup_subscriptions = var.enable_cleanup_subscriptions
  enable_reconfigure           = var.enable_reconfigure
  epilog_d                     = var.epilog_d
  login_network_storage        = var.login_network_storage
  network_storage              = var.network_storage
  partitions                   = values(module.slurm_partition)[*]
  prolog_d                     = var.prolog_d
  slurmdbd_conf_tpl            = var.slurmdbd_conf_tpl
  slurm_conf_tpl               = var.slurm_conf_tpl
}

######################
# CONTROLLER: HYBRID #
######################

module "slurm_controller_hybrid" {
  source = "../slurm_controller_hybrid"

  count = var.enable_hybrid ? 1 : 0

  slurm_cluster_name = var.slurm_cluster_name
  project_id         = var.project_id
  slurm_cluster_id   = local.slurm_cluster_id

  google_app_cred_path         = var.controller_hybrid_config.google_app_cred_path
  slurm_bin_dir                = var.controller_hybrid_config.slurm_bin_dir
  slurm_log_dir                = var.controller_hybrid_config.slurm_log_dir
  output_dir                   = var.controller_hybrid_config.output_dir
  cloud_parameters             = var.cloud_parameters
  compute_d                    = var.compute_d
  enable_devel                 = var.enable_devel
  enable_bigquery_load         = var.enable_bigquery_load
  enable_cleanup_compute       = var.enable_cleanup_compute
  enable_cleanup_subscriptions = var.enable_cleanup_subscriptions
  enable_reconfigure           = var.enable_reconfigure
  epilog_d                     = var.epilog_d
  partitions                   = values(module.slurm_partition)[*]
  prolog_d                     = var.prolog_d
}

###################
# LOGIN: TEMPLATE #
###################

module "slurm_login_template" {
  source = "../slurm_instance_template"

  for_each = {
    for x in var.login_nodes : x.group_name => x
    if(x.instance_template == null || x.instance_template == "")
  }

  additional_disks         = each.value.additional_disks
  can_ip_forward           = each.value.can_ip_forward
  slurm_cluster_name       = var.slurm_cluster_name
  disable_smt              = each.value.disable_smt
  disk_auto_delete         = each.value.disk_auto_delete
  disk_labels              = each.value.disk_labels
  disk_size_gb             = each.value.disk_size_gb
  disk_type                = each.value.disk_type
  enable_confidential_vm   = each.value.enable_confidential_vm
  enable_oslogin           = each.value.enable_oslogin
  enable_shielded_vm       = each.value.enable_shielded_vm
  gpu                      = each.value.gpu
  labels                   = each.value.labels
  machine_type             = each.value.machine_type
  metadata                 = each.value.metadata
  min_cpu_platform         = each.value.min_cpu_platform
  on_host_maintenance      = each.value.on_host_maintenance
  preemptible              = each.value.preemptible
  project_id               = var.project_id
  region                   = each.value.region
  service_account          = each.value.service_account
  shielded_instance_config = each.value.shielded_instance_config
  slurm_cluster_id         = local.slurm_cluster_id
  slurm_instance_role      = "login"
  source_image_family      = each.value.source_image_family
  source_image_project     = each.value.source_image_project
  source_image             = each.value.source_image
  subnetwork_project       = each.value.subnetwork_project
  subnetwork               = each.value.subnetwork
  tags                     = concat([var.slurm_cluster_name], each.value.tags)
}

###################
# LOGIN: TEMPLATE #
###################

module "slurm_login_instance" {
  source = "../slurm_login_instance"

  for_each = { for x in var.login_nodes : x.group_name => x }

  access_config      = lookup(each.value, "access_config", [])
  slurm_cluster_name = var.slurm_cluster_name
  instance_template = (
    each.value.instance_template != null && each.value.instance_template != ""
    ? each.value.instance_template
    : module.slurm_login_template[each.key].self_link
  )
  num_instances    = each.value.num_instances
  project_id       = var.project_id
  region           = each.value.region
  slurm_cluster_id = local.slurm_cluster_id
  static_ips       = each.value.static_ips
  subnetwork       = each.value.subnetwork
  zone             = each.value.zone

  metadata = {
    slurm_depends_on_controller = var.enable_hybrid ? null : sha256(module.slurm_controller_instance[0].slurm_controller_instance.instances_details[0].id)
  }

  depends_on = [
    # Ensure Controller is up before attempting to mount file systems from it
    module.slurm_controller_instance[0].slurm_controller_instance,
  ]
}
