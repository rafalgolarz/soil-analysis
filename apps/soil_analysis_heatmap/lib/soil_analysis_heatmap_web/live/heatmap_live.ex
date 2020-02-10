defmodule SoilAnalysisHeatmapWeb.HeatmapLive do
  @moduledoc false
  use Phoenix.LiveView
  alias SoilAnalysis
  require Logger

  def render(assigns) do
    Logger.info("RENDER #{inspect(self())}")

    ~L"""
    <div>
      <div>
        <form phx-submit="visualize">
          <input name="input_data" id="input-data" placeholder="Enter input" value="<%= @input %>" />
          <div>
            <button type="submit">SCORE</button>
          </div>
        </form>
      </div>

      <div id="local-score">&nbsp</div>
      <div id="wrapper">
        <%= for {pos, val} <- @scores do %>
          <div class="cell" style="filter: contrast(0.<%= div(val, @size)%>);" title="<%= val %>" onclick="document.getElementById('local-score').innerHTML = '<%= val %>'";>
          &nbsp;
          </div>
          <%= if rem(pos+1, @size) == 0 do %>
          <br>
          <% end %>
        <% end %>
      </div>
    </div>
    """
  end

  def mount(_params, socket) do
    Logger.info("MOUNT #{inspect(self())}")

    socket =
      socket
      |> assign(:size, 0)
      |> assign(:scores, [])
      |> assign(:input, "")

    {:ok, socket}
  end

  def handle_event("visualize", %{"input_data" => input_data}, socket) do
    Logger.info("handle_event #{inspect(input_data)}")
    send(self(), {:visualize, input_data})
    {:noreply, assign(socket, input_data: input_data)}
  end

  def handle_info({:visualize, input_data}, socket) do
    Logger.info("handle_info #{inspect(input_data)}")

    listed =
      input_data
      |> SoilAnalysis.input_to_list()

    [_ | tail] = listed
    [size_of_the_grid | _] = tail

    result = score(input_data)
    {:noreply, assign(socket, scores: result, size: size_of_the_grid)}
  end

  # transform {x, y, score} to an ordrered list of scores [{0, 2}, {1, 10}, {2, 4}, {3, 10}]
  # that we it's easier to draw it in html
  def score(input) do
    tuples =
      input
      |> SoilAnalysis.process()

    for {{_, v}, counter} <- Enum.with_index(tuples), do: {counter, v}
  end
end
