data "google_compute_image" "centos_7" {
  provider = google-beta

  family  = "centos-7"
  project = "centos-cloud"
}