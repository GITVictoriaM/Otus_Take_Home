
#Create a documents collection from metrics server yaml
data "kubectl_file_documents" "metrics_docs" {
    content = file("metrics_server.yaml")
}

resource "kubectl_manifest" "metrics_ingress_controller" {
    depends_on = [aws_eks_node_group.Otus_Demo_NG]
    for_each   = data.kubectl_file_documents.metrics_docs.manifests
    yaml_body  = each.value
}
#Create a documents collection from inginx ingress yaml
data "kubectl_file_documents" "nginx_docs" {
    content = file("nginx-ingress.yml")
}

resource "kubectl_manifest" "nginx_ingress_controller" {
    depends_on = [aws_eks_node_group.Otus_Demo_NG]
    for_each   = data.kubectl_file_documents.nginx_docs.manifests
    yaml_body  = each.value
}
#Create a documents collection from hello world app
data "kubectl_file_documents" "hello_docs" {
    content = file("hello-world-all.yaml")
}

resource "kubectl_manifest" "hello_world_ingress_controller" {
    depends_on = [aws_eks_node_group.Otus_Demo_NG, kubectl_manifest.nginx_ingress_controller]
    for_each   = data.kubectl_file_documents.hello_docs.manifests
    yaml_body  = each.value
}