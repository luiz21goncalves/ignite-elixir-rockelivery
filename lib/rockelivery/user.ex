defmodule Rockelivery.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset
  alias Rockelivery.Order

  @primary_key {:id, :binary_id, autogenerate: true}

  @required_params [:age, :address, :cep, :cpf, :email, :password, :name]
  @update_params @required_params -- [:password]

  @mail_regex ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/

  @derive {
    Jason.Encoder,
    only: [:id, :age, :address, :cep, :cpf, :email, :name, :inserted_at, :updated_at]
  }

  schema "users" do
    field :age, :integer
    field :address, :string
    field :cep, :string
    field :cpf, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :name, :string

    has_many :orders, Order

    timestamps()
  end

  def build(changeset), do: apply_action(changeset, :create)

  def changeset(params) do
    %__MODULE__{}
    |> validate(params, @required_params)
  end

  def changeset(struct, params) do
    struct
    |> validate(params, @update_params)
  end

  defp validate(struct, params, fields) do
    struct
    |> cast(params, fields)
    |> validate_required(fields)
    |> validate_length(:password, min: 6)
    |> validate_length(:cep, is: 8)
    |> validate_length(:cpf, is: 11)
    |> validate_number(:age, greater_than_or_equal_to: 18)
    |> validate_format(:email, @mail_regex)
    |> unique_constraint([:email])
    |> unique_constraint([:cpf])
    |> put_password_hash()
  end

  defp put_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    password_hash = Pbkdf2.hash_pwd_salt(password)

    change(changeset, %{password_hash: password_hash})
  end

  defp put_password_hash(changeset), do: changeset
end
