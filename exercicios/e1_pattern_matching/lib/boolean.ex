defmodule Boolean do

  def b_not(true) do false end
  def b_not(false) do true end


  def b_and(true,true) do true end
  def b_and(_,_) do false end

  def b_or(false,false) do false end
  def b_or(_,_) do true end


end
