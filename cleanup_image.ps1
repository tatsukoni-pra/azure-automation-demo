# 定数設定
$ACR_NAME = "acrtatsukonidemo"
$REPOSITORY = "servicebus-receiver"
$KEEP_LATEST = 50

az login --identity

# タイムスタンプでソートされたタグの一覧を取得
$all_tags = az acr repository show-tags --name $ACR_NAME --repository $REPOSITORY --orderby time_asc --output tsv

# タグの文字列を配列に変換
if ($all_tags -is [array]) {
    # すでに配列の場合はそのまま使用
    $all_tags_array = $all_tags
} else {
    # 文字列の場合は改行で分割
    $all_tags_array = $all_tags -split "`n" | Where-Object { $_ -ne "" }
}

# タグの総数をカウント
$all_tag_count = $all_tags_array.Count

# 削除すべきタグ数を計算
if ($all_tag_count -le $KEEP_LATEST) {
    Write-Output "削除するタグはありません。現在のタグ数 ($all_tag_count) が保持数 ($KEEP_LATEST) 以下です。"
    exit 0
}
$delete_tag_count = $all_tag_count - $KEEP_LATEST
Write-Output "削除対象イメージ数: $delete_tag_count (合計: $all_tag_count, 保持: $KEEP_LATEST)"

# 削除するタグを特定
$tags_to_delete = $all_tags_array[0..($delete_tag_count-1)]
Write-Output "削除対象のタグ:"
$tags_to_delete | ForEach-Object { Write-Output $_ }

# 削除を実行
foreach ($tag_to_delete in $tags_to_delete) {
    Write-Output "削除中: $REPOSITORY`:$tag_to_delete"
    az acr repository delete --name $ACR_NAME --image "$REPOSITORY`:$tag_to_delete" --yes
}

Write-Output "クリーンアップ完了！"
