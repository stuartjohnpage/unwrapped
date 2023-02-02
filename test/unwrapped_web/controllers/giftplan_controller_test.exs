defmodule UnwrappedWeb.GiftplanControllerTest do
  use UnwrappedWeb.ConnCase

  import Unwrapped.GiftplansFixtures

  @create_attrs %{gift_from_id: 42, gift_to_id: 42, name: "some name"}
  @update_attrs %{gift_from_id: 43, gift_to_id: 43, name: "some updated name"}
  @invalid_attrs %{gift_from_id: nil, gift_to_id: nil, name: nil}

  describe "index" do
    test "lists all giftplans", %{conn: conn} do
      conn = get(conn, Routes.giftplan_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Giftplans"
    end
  end

  describe "new giftplan" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.giftplan_path(conn, :new))
      assert html_response(conn, 200) =~ "New Giftplan"
    end
  end

  describe "create giftplan" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.giftplan_path(conn, :create), giftplan: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.giftplan_path(conn, :show, id)

      conn = get(conn, Routes.giftplan_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Giftplan"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.giftplan_path(conn, :create), giftplan: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Giftplan"
    end
  end

  describe "edit giftplan" do
    setup [:create_giftplan]

    test "renders form for editing chosen giftplan", %{conn: conn, giftplan: giftplan} do
      conn = get(conn, Routes.giftplan_path(conn, :edit, giftplan))
      assert html_response(conn, 200) =~ "Edit Giftplan"
    end
  end

  describe "update giftplan" do
    setup [:create_giftplan]

    test "redirects when data is valid", %{conn: conn, giftplan: giftplan} do
      conn = put(conn, Routes.giftplan_path(conn, :update, giftplan), giftplan: @update_attrs)
      assert redirected_to(conn) == Routes.giftplan_path(conn, :show, giftplan)

      conn = get(conn, Routes.giftplan_path(conn, :show, giftplan))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, giftplan: giftplan} do
      conn = put(conn, Routes.giftplan_path(conn, :update, giftplan), giftplan: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Giftplan"
    end
  end

  describe "delete giftplan" do
    setup [:create_giftplan]

    test "deletes chosen giftplan", %{conn: conn, giftplan: giftplan} do
      conn = delete(conn, Routes.giftplan_path(conn, :delete, giftplan))
      assert redirected_to(conn) == Routes.giftplan_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.giftplan_path(conn, :show, giftplan))
      end
    end
  end

  defp create_giftplan(_) do
    giftplan = giftplan_fixture()
    %{giftplan: giftplan}
  end
end
