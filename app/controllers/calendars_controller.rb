class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    # params.require(:モデル名).permit(キー)
    params.require(:plan).permit(:plan,:date) 
    # :carendersを:plansに変更↓↓
    #  params.require(:plans).permit(:date, :plan) 
    # 試しにrequire(:calendars)を削除↓↓
    # params.permit(:date, :plan)
  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)  今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    @plans = Plan.where(date: @todays_date..@todays_date + 7)

    # 曜日を１週間分、一覧表示する 「+ x」を付属させることで１週間分の表示を可能にする
    7.times do |x|
      plans = []
      # mapはeachの様な働きをするメソッド
      plan = @plans.map do |plan|
        #pushを用いることで、配列plans[]にplanカラム(黄色)のplan(水色)を代入している
        # 処理内容とif文が逆に記述されている
        plans.push(plan.plan) if plan.date == @todays_date + x
      end

    # ビューファイルに渡す値はここでハッシュを用いて定義されている
      days = { month: (@todays_date + x).month, date: (@todays_date+x).day, plans: plans, youbi: wdays[(@todays_date + x).wday] }
      @week_days.push(days)
    end

  end
end
