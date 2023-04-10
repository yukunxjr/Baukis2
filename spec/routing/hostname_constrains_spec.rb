require "rails_helper"

describe "ルーティング" do
  example "職員トップページ" do
    url = "/"
    expect(get: url).to route_to(
      controller: "staff/top",
      action: "index"
    )
  end

  example "管理者ログインフォーム" do
    url = "admin/login"
    expect(get: url).to route_to(
      controller: "admin/sessions",
      action: "new"
    )
  end

  example "顧客トップページ" do
    url = "/customer"
    expect(get: url).to route_to(
      controller: "customer/top",
      action: "index"
    )
  end

end

