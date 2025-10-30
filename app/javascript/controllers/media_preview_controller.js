// app/javascript/controllers/media_preview_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]

  connect() {
    this.selectedFiles = [] 
  }

  previewFiles(event) {
    const files = Array.from(event.target.files)
    this.selectedFiles = this.selectedFiles.concat(files)
    this.renderPreviews()
  }

  renderPreviews() {
    this.previewTarget.innerHTML = ""

    this.selectedFiles.forEach((file, index) => {
      const reader = new FileReader()
      reader.onload = e => {
        const wrapper = document.createElement("div")
        wrapper.classList.add("position-relative", "d-inline-block", "me-2", "mb-2")

        let element
        if (file.type.startsWith("image/")) {
          element = document.createElement("img")
          element.src = e.target.result
          element.classList.add("img-thumbnail")
          element.style.maxWidth = "150px"
        } else if (file.type.startsWith("video/")) {
          element = document.createElement("video")
          element.src = e.target.result
          element.controls = true
          element.classList.add("d-block")
          element.style.maxWidth = "150px"
        } else if (file.type.startsWith("audio/")) {
          element = document.createElement("audio")
          element.src = e.target.result
          element.controls = true
          element.classList.add("d-block")
        }

        // ❌ 取り消しボタン
        const removeBtn = document.createElement("button")
        removeBtn.type = "button"
        removeBtn.innerHTML = "&times;"
        removeBtn.classList.add("btn", "btn-sm", "btn-danger", "position-absolute", "top-0", "end-0")
        removeBtn.addEventListener("click", () => this.removeFile(index))

        wrapper.appendChild(element)
        wrapper.appendChild(removeBtn)
        this.previewTarget.appendChild(wrapper)
      }

      reader.readAsDataURL(file)
    })

    this.updateInputFiles()
  }

  removeFile(index) {
    this.selectedFiles.splice(index, 1)
    this.renderPreviews()
  }

  updateInputFiles() {
    const dataTransfer = new DataTransfer()
    this.selectedFiles.forEach(file => dataTransfer.items.add(file))
    this.inputTarget.files = dataTransfer.files
  }
}


// Array.from(files) → FileList を配列に変換
// .forEach(file => ...) → 1つずつのファイルを処理
// const reader = new FileReader() → ファイルを読み込むための箱を作る
// reader.onload = e => { ... } → 読み込み完了時にプレビューを作る


// 1. <input type="file"> の役割
// 実際の フォーム送信時にサーバに送るファイル を保持する場所
// ユーザーが「ファイルを選ぶ」だけで自動で input.files にセットされる
// ただし、JavaScript から直接削除や並べ替えができない（splice などは使えない）

// 2. selectedFiles の役割
// JavaScript 上で自由に操作できる配列
// ファイルの追加や削除、順序変更などが簡単にできる
// プレビュー表示や削除ボタンの挙動もここで管理する

// 3. 二つが必要な理由
// <input> 単体では「削除」や「プレビュー表示」の管理が難しい
// selectedFiles にファイルをコピーして管理することで 見た目（プレビュー）と送信データを分けてコントロールできる
// updateInputFiles() で selectedFiles を <input> に反映することで、送信されるファイルを常に最新に保つ

// selectedFiles と input をただ紐づけは意味がない。
// なぜなら見た目の配列は更新できるが、input.files は変わらず → 削除しても送信される
// DataTransfer を経由して input.files に代入	input.files が更新され、送信データが最新状態になる
