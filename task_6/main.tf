provider "google" {
  project = "infra-optics-379215"
  region  = "us-central1"
  zone    = "us-central1-c"

}


resource "google_storage_default_object_access_control" "public_rule" {
  bucket = google_storage_bucket.bucket.name
  role   = "READER"
  entity = "allUsers"
}

resource "google_storage_bucket" "bucket" {
  name     = "dareit-tf"
  location = "us-central1"
}


resource "google_compute_instance" "dare-id-vm" {
  name         = "dareit-vm-tf"
  machine_type = "e2-medium"
  zone         = "us-central1-a"


  tags = ["dareit"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        managed_by_terraform = "true"

      }

    }

  }

  network_interface {

    network = "default"

    access_config {

      // Ephemeral public IP

    }

  }

}

resource "google_sql_database_instance" "main" {
  name             = "dareit"
  database_version = "POSTGRES_14"
  region           = "us-central1"

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
  }
}

resource "google_sql_dstabase" "database" {
    name = "dareit"
    instance = google_sql_database_instance.dareit.name
}

resource "google_sql_user" "usertf" {
    name = "dareit_user"
    instance = google_sql_database_instance.dareit.name
    password = "admin"
}









/* NOTATKI
err1
│ Error: Reference to undeclared resource
│
│   on main.tf line 69, in resource "google_sql_database" "database":
│   69:     instance = google_sql_database_instance.dareit.name
│
│ A managed resource "google_sql_database_instance" "dareit" has not been declared in the root module.
╵
╷
│ Error: Reference to undeclared resource
│
│   on main.tf line 74, in resource "google_sql_user" "usertf":
│   74:     instance = google_sql_database_instance.dareit.name
│
│ A managed resource "google_sql_database_instance" "dareit" has not been declared in the root module.



err2
Error: Error, failed to create instance dareit: googleapi: Error 403: sqladmin API (prod) has not been used in project 258379575329 before or it is disabled. Enable it by visiting https://console.developers.google.com/apis/api/sqladmin.googleapis.com/overview?project=258379575329 then retry. If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry.
│ Details:
*/