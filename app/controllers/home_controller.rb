class HomeController < ApplicationController
  def index
    @q = Knowhow.ransack(params[:q])
    # 検索結果を取得して配列に変換 → シャッフル → 6個だけ
    @knowhows = @q.result(distinct: true)
                   .includes(:user, media_files_attachments: :blob)
                   .to_a.shuffle.first(3)

    @knowhows.shuffle!
  end
end
