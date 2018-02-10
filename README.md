# A simple liststore example

The goal behind this example was to show the use of a Treeview with Objects in the model and how to avoid data replication by using the ListStore (could be a treestore) as the only container of references to the data objects. 

As using objects is vague and generic we must map the object fields and/or properties to the treeview columns.

## The Model (ListStore)

The model is prepared to contains Objects of type SomeObject:

```Vala
Gtk.ListStore list_store = new Gtk.ListStore (1, typeof (SomeObject));
```

And we add a few example instances of SomeObjects:

```Vala
list_store.append (out iter);
list_store.set (iter, 0, new SomeObject.with_name ("Joe"));
list_store.append (out iter);
list_store.set (iter, 0, new SomeObject.with_name ("Jane"));
list_store.append (out iter);
list_store.set (iter, 0, new SomeObject.with_name ("Ada"));
list_store.append (out iter);
list_store.set (iter, 0, new SomeObject.with_name ("Jarvis"));
```

## Changes to objects in the model

To change an object, we should retrieve it from the model, do some changes and set the object to the model. To exemplify, we added a toggle button that will change the name of the object, at row 3, from Ada to Megatron and vice versa:

```Vala
Gtk.ToggleButton button = new Gtk.ToggleButton.with_label ("Change obj at row 3");
button.toggled.connect (() => {
   Gtk.TreeIter niter;
   SomeObject obj;
   list_store.get_iter_from_string (out niter, "2");
   list_store.@get (niter, 0, out obj);
   if (button.active) {
      obj.name = "Megatron";
   } else {
      obj.name = "Ada";
   }
   list_store.@set (niter, 0, obj);
});
```

## Map data between the model and the view

To map data from the object we'll use *data_functions* which allow us to "bind" or adapt these fields into the cell renderers:

```Vala
Gtk.CellRendererText cell = new Gtk.CellRendererText ();
view.insert_column_with_data_func (-1, "Name", cell, (column, cell, model, iter) => { 
   SomeObject obj;
   model.@get (iter, 0, out obj);
   (cell as Gtk.CellRendererText).text = obj.name;
});
```

