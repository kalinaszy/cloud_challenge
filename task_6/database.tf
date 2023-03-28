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
