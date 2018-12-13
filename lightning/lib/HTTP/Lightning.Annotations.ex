defmodule Lightning.Annotations do
  defmacro __using__(args) do
    quote do
      def __on_annotation_(_) do
        quote do end
      end
      @annotations %{}
      @supported_annotations unquote(args)
      @on_definition { unquote(__MODULE__), :__on_definition__ }
      @before_compile { unquote(__MODULE__), :__before_compile__ }
      import Lightning.Annotations
      require Lightning.Annotations
    end
  end

  def __on_definition__(env, kind, name, args, guards, body) do
    # TODO
    # GET path to route
    # Generate path 
   
    # route = Enum.at(args, 1) |> Enum.join("/")
    # IO.inspect route
    
    Module.get_attribute(env.module, :supported_annotations) |> Enum.each &annotate_method(&1, env.module, name, args)
  end

  def get_path(args) when length(args) > 0 do
    args 
    |> Enum.join("/")
  end

  def get_path(args) when length(args) < 0 or is_nil(args) do
    []
  end

  def get_pat

  def annotate_method(annotation, module, method, route) do
    annotations = Module.get_attribute(module, :annotations)
    value = Module.get_attribute(module, annotation)
    Module.delete_attribute(module, annotation)
    update_annotations(annotation, annotations, module, method, value, route)
  end

  def update_annotations(_, _, _, _, nil), do: :no_op

  def update_annotations(annotation, annotations, module, method, value, route) do
    method_annotations = Map.get(annotations, method, []) ++ [%{ annotation: annotation, value: value, route: route}]
    Module.put_attribute(module, :annotations, annotations |> Map.put(method, method_annotations))
  end

  defmacro __before_compile__(env) do
    quote do
      def annotations do
         @annotations
      end

      def annotated_with(annotation) do
        methods = @annotations |> Map.keys
        methods |> Enum.filter fn method ->
           Map.get(@annotations, method, [])
            |> Enum.map(fn a -> a.annotation end)
            |> Enum.member?(annotation)
        end
      end
    end

  end
end
