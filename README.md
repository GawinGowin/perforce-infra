# Perforce-infra

## 事前作成済みリソース
```tf
resource "google_artifact_registry_repository" "container_repo" {
  location      = "asia-northeast1"
  repository_id = var.instance_name
  description   = "created_by:terraform"
  format        = "DOCKER"
}
```

## リソースのライフサイクル
- コンテナのアップデート(CDは非整備)
```
make push
```
- インフラの作成
  1. GCP上にリソース作成
  ```
  make apply
  ```
  2. **スーパーユーザーのパスワードがデフォルトのままなので適宜修正**

- 削除
```
cd terraform && terraform destroy
```

## アクセス先
以下で作成したipアドレス:1666(デフォルト)
```tf
resource "google_compute_address" "perforce_ip" {
  name   = "${var.instance_name}-ip"
  region = "asia-northeast1"
}
```