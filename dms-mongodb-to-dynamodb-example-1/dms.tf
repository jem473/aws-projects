resource "aws_dms_replication_instance" "replication_instance" {
    allocated_storage = var.replication_instance_allocated_storage
    availability_zone = var.replication_instance_availability_zone
    multi_az = var.replication_instance_multi_az
    preferred_maintenance_window = var.replication_instance_preferred_maintenance_window
    replication_instance_class = var.replication_instance_class
    replication_instance_id = var.replication_instance_id

    publicly_accessible = true
}