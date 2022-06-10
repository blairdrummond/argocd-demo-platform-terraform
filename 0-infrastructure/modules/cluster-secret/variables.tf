variable "name" {
    description = "name of the cluster"
}

variable "server_url" {
    description = "server url"
}

variable "ca_data" {
    description = "certificate authority data (base64)"
}

variable "cert_data" {
    description = "certificate data (base64)"
}

variable "key_data" {
    description = "client key data (base64)"
}
