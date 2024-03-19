resource "google_compute_autoscaler" "default" {
  provider = google-beta

  name   = var.ASG_name
  zone   = var.zone
  target = google_compute_instance_group_manager.default.id

  autoscaling_policy {
    max_replicas    = var.maximum_instances
    min_replicas    = var.minimum_instances
    cooldown_period = 60
  }
}

resource "google_compute_instance_template" "default" {
  provider = google-beta

  name           = var.template_name
  machine_type   = var.machine_type
  can_ip_forward = false

  tags = ["foo", "bar"]

  disk {
    source_image = data.google_compute_image.centos_7.id
  }

  network_interface {
    network = "default"
  }

  metadata = {
    foo = "bar"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_target_pool" "default" {
  provider = google-beta

  name = var.targetpool_name
}

resource "google_compute_instance_group_manager" "default" {
  provider = google-beta

  name = var.igm_name
  zone = var.zone

  version {
    instance_template = google_compute_instance_template.default.id
    name              = var.data_base_version
  }

  target_pools       = [google_compute_target_pool.default.id]
  base_instance_name = "autoscaler-sample"