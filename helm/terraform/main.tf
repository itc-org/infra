resource "helm_release" "monitoring" {
  name  = "monitoring"
  chart = "${path.module}/../prometheus"

  namespace        = "monitoring"
  create_namespace = true

  values = [
    file("${path.module}/../prometheus/values.yaml")
  ]
}

resource "helm_release" "postgres" {
  name  = "postgres"
  chart = "${path.module}/../postgresql"

  namespace        = "database"
  create_namespace = true

  values = [
    file("${path.module}/../postgresql/values.yaml")
  ]
}

# resource "helm_release" "kafka" {
#   name  = "kafka"
#   chart = "${path.module}/../kafka"

#   namespace        = "kafka"
#   create_namespace = true

#   values = [
#     file("${path.module}/../kafka/values.yaml")
#   ]
# }