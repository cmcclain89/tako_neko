defmodule TakoNeko.Response do
  alias TakoNeko.Request

  defstruct [
    :first,
    :prev,
    :next,
    :last,
    # :limit,
    # :etag,
    :body
  ]

  # @typep limit :: %{max: non_neg_integer, remaining: non_neg_integer}
  @type t :: %__MODULE__{
          first: Request.t() | nil,
          prev: Request.t() | nil,
          next: Request.t() | nil,
          last: Request.t() | nil,
          # limit: limit(),
          # etag: String.t(),
          body: map | list | struct | nil
        }

  def new(%Req.Response{} = response, %TakoNeko.Client{} = client) do
    takoneko_resp = %__MODULE__{body: response.body}

    format_links(response.headers)
    |> Enum.reduce(takoneko_resp, fn {key, link}, acc ->
      %{acc | key => build_request(link, client)}
    end)
  end

  def new(%Req.Response{} = response, %TakoNeko.Client{} = client, module) do
    new(response, client)
    |> with_casted_response_body(module)
  end

  # todo: get the expected atoms set up ahead of time, use to_existing_atom
  def format_links(%{"link" => links}) do
    hd(links)
    |> String.split(", ")
    |> Enum.map(fn link ->
      [url, rel] = String.split(link, "; ")

      rel =
        String.split(rel, "=")
        |> Enum.reverse()
        |> hd
        |> String.replace("\"", "")
        |> String.to_atom()

      url =
        String.replace(url, "<", "")
        |> String.replace(">", "")

      {rel, url}
    end)
  end

  def format_links(%{}), do: %{}

  def build_request(link, client) do
    as_uri = URI.parse(link)

    params =
      as_uri.query
      |> String.split("&")
      |> Enum.map(fn param ->
        [key, val] = String.split(param, "=")
        {String.to_atom(key), val}
      end)

    # eventually can add headers too
    TakoNeko.Request.new(client, params)
  end

  @spec with_casted_response_body(TakoNeko.Response.t(), module) :: TakoNeko.Response.t()
  def with_casted_response_body(%TakoNeko.Response{} = response, module) do
    case response.body do
      [%{} | _] ->
        body =
          Enum.map(response.body, fn event ->
            atomized_event =
              Enum.map(event, fn {k, v} ->
                {String.to_atom(k), v}
              end)

            struct(module, atomized_event)
          end)

        %TakoNeko.Response{response | body: body}

      unexpected ->
        IO.inspect(unexpected)
        raise ArgumentError, "bummer!"
    end
  end
end

# "access-control-allow-origin" => ["*"],
# "access-control-expose-headers" => ["ETag, Link, Location, Retry-After, X-GitHub-OTP, X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Used, X-RateLimit-Resource, X-RateLimit-Reset, X-OAuth-Scopes, X-Accepted-OAuth-Scopes, X-Poll-Interval, X-GitHub-Media-Type, X-GitHub-SSO, X-GitHub-Request-Id, Deprecation, Sunset"],
# "cache-control" => ["private, max-age=60, s-maxage=60"],
# "content-security-policy" => ["default-src 'none'"],
# "content-type" => ["application/json; charset=utf-8"],
# "date" => ["Sun, 02 Jun 2024 05:27:04 GMT"],
# "etag" => ["W/\"ee074c3db9817aee470280f7125505dcca54b4e6a20c05917590f9043a634633\""],
# "github-authentication-token-expiration" => ["2024-09-01 15:00:00 UTC"],
# "last-modified" => ["Tue, 28 May 2024 06:01:10 GMT"],
# "link" => ["<https://api.github.com/organizations/65760653/events?page=1&per_page=1>; rel=\"prev\", <https://api.github.com/organizations/65760653/events?page=3&per_page=1>; rel=\"next\", <https://api.github.com/organizations/65760653/events?page=30&per_page=1>; rel=\"last\", <https://api.github.com/organizations/65760653/events?page=1&per_page=1>; rel=\"first\""],
# "referrer-policy" => ["origin-when-cross-origin, strict-origin-when-cross-origin"],
# "server" => ["GitHub.com"],
# "strict-transport-security" => ["max-age=31536000; includeSubdomains; preload"],
# "transfer-encoding" => ["chunked"],
# "vary" => ["Accept, Authorization, Cookie, X-GitHub-OTP",
#  "Accept-Encoding, Accept, X-Requested-With"],
# "x-accepted-oauth-scopes" => [""],
# "x-content-type-options" => ["nosniff"],
# "x-frame-options" => ["deny"],
# "x-github-api-version-selected" => ["2022-11-28"],
# "x-github-media-type" => ["github.v3; format=json"],
# "x-github-request-id" => ["DDFA:2F9333:2B74252:2CAD373:665C02A8"],
# "x-oauth-scopes" => ["notifications, read:audit_log, read:discussion, read:enterprise, read:gpg_key, read:org, read:project, read:public_key, read:repo_hook, read:ssh_signing_key, read:user, repo, user:email, workflow"],
# "x-poll-interval" => ["60"],
# "x-ratelimit-limit" => ["5000"],
# "x-ratelimit-remaining" => ["4995"],
# "x-ratelimit-reset" => ["1717308899"],
# "x-ratelimit-resource" => ["core"],
# "x-ratelimit-used" => ["5"],
# "x-xss-protection" => ["0"]
