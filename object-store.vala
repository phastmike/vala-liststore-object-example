/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */ 
/* 
 * object-store.vala 
 * 
 * A ListStore example, containing Objects.
 * 
 * Author: José Miguel Fonte 
 */

public class SomeObject : Object {
    public string name {set;get;default = "";}
    public uint age {set;get;default = 0;}

    public SomeObject.with_name (string name) {
        this.name = name;
    }
}

public class Application : Gtk.Window {

	public Application () {
		// Prepare Gtk.Window:
        this.title = "Demo";
        this.window_position = Gtk.WindowPosition.CENTER;
        this.destroy.connect (Gtk.main_quit);
        this.set_default_size (350, 70);

        Gtk.Box box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);

        // The Model:
        Gtk.ListStore list_store = new Gtk.ListStore (1, typeof (SomeObject));
        Gtk.TreeIter iter;

        list_store.append (out iter);
        list_store.set (iter, 0, new SomeObject.with_name ("Joe"));
        list_store.append (out iter);
        list_store.set (iter, 0, new SomeObject.with_name ("Jane"));
        list_store.append (out iter);
        list_store.set (iter, 0, new SomeObject.with_name ("Ada"));
        list_store.append (out iter);
        list_store.set (iter, 0, new SomeObject.with_name ("Jarvis"));

        // The View:
        Gtk.TreeView view = new Gtk.TreeView.with_model (list_store);
        box.add (view);

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
        box.add (button);

        this.add (box);
        Gtk.CellRendererText cell = new Gtk.CellRendererText ();
        view.insert_column_with_data_func (-1, "Name", cell, (column, cell, model, iter) => { 
            SomeObject obj;
            model.@get (iter, 0, out obj); 
            (cell as Gtk.CellRendererText).text = obj.name;
        }); 
	}

    public static int main (string[] args) {
        Gtk.init (ref args);

        Application app = new Application ();
        app.show_all ();
        Gtk.main ();
        return 0;
    }
}
