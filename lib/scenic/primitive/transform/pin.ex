#
#  Created by Boyd Multerer on 10/03/17.
#  Copyright © 2017 Kry10 Industries. All rights reserved.
#

defmodule Scenic.Primitive.Transform.Pin do
  use Scenic.Primitive.Transform

  # serialized pin is always a 3-tuple of integers.  {x, y, z}


  #============================================================================
  # data verification and serialization

  #--------------------------------------------------------
  def info(), do: "Transform :pin must be a 2d, or 3d point {x,y} or {x,y,z}\n"

  #--------------------------------------------------------
  def verify( pin )
  def verify( {x,y} ) when is_integer(x) and is_integer(y), do: true
  def verify( {x,y,z} ) when is_integer(x) and is_integer(y) and is_integer(z), do: true
  def verify( _ ), do: false

  #--------------------------------------------------------
  def serialize( data, order \\ :native )
  def serialize( {x,y}, order ), do: serialize( {x,y,0}, order )
  def serialize( {x,y,z}, :native ) do
    {:ok, <<
      x :: integer-size(16)-native,
      y :: integer-size(16)-native,
      z :: integer-size(16)-native
    >>}
  end
  def serialize( {x,y,z}, :big ) do
    {:ok, <<
      x :: integer-size(16)-big,
      y :: integer-size(16)-big,
      z :: integer-size(16)-big
    >>}
  end

  #--------------------------------------------------------
  def deserialize( mx, order \\ :native )
  def deserialize( <<
      x   :: integer-size(16)-native,
      y   :: integer-size(16)-native,
      0   :: integer-size(16)-native,
      bin :: binary
    >>, :native
 ), do: {:ok, {x, y}, bin}
  def deserialize( <<
      x   :: integer-size(16)-native,
      y   :: integer-size(16)-native,
      z   :: integer-size(16)-native,
      bin :: binary
    >>, :native
 ), do: {:ok, {x, y, z}, bin}

  def deserialize( <<
      x   :: integer-size(16)-big,
      y   :: integer-size(16)-big,
      0   :: integer-size(16)-big,
      bin :: binary
    >>, :big
 ), do: {:ok, {x, y}, bin}
  def deserialize( <<
      x   :: integer-size(16)-big,
      y   :: integer-size(16)-big,
      z   :: integer-size(16)-big,
      bin :: binary
    >>, :big
 ), do: {:ok, {x, y, z}, bin}

  def deserialize( binary_data, order ), do: {:err_invalid, binary_data, order }


end