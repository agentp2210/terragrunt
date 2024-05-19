include "root" {
  path = find_in_parent_folders()
}

inputs = {
  instance_count = 2
  instance_type  = "t3.micro"
}