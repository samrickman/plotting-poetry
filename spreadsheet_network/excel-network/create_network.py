from network_functions import load_data, calculate_linked_sheets, \
    get_linked_sheets_dict, get_sheet_colors_dict, delete_sheets_to_ignore, \
    get_edges, get_nodes, write_constants_file, create_output_directory
import tkinter as tk
from tkinter import ttk, filedialog, messagebox, HORIZONTAL, END

#input_filename = "../s_without_graphs.xlsm"
sheets_to_ignore = [
    ]
outdir = "network_graph"

def open_file(file):
    create_network(file)

def browse(event):
    excel_file = filedialog.askopenfilename(title = "Select spreadsheet to convert", 
            filetypes = [("Excel files", ["*.xlsx", "*.xlsm"])])
    create_network(excel_file)

class MainWindow(tk.Tk):
    
    
    def __init__(self, *args, **kwargs):
        
        tk.Tk.__init__(self, *args, **kwargs)

        self.geometry("1000x1000")


        label = tk.Label(self, text=("Create network"), font=("Verdana", 12))
        label.pack(pady=10,padx=10)


        self.mainlabel = tk.Label(self, text="Please select an Excel file to create a network")

        start_button = tk.Button(self, text = "Select a file")

        start_button.bind("<Button-1>", browse)

        self.sheet_list = tk.Listbox(self, selectmode = tk.EXTENDED)
        self.sheet_list.pack()

        self.reading_in_label = tk.Label(self, text="Reading in file")
        self.processing_label = tk.Label(self, text="Processing data...")
        self.saving_label = tk.Label(self, text = "Saving data")
        file_saved_label = tk.Label(self, text="File saved!")
        self.mainlabel.pack()

        """
        self.file_to_read_in = filedialog.askopenfilename(title = "Select spreadsheet to convert", 
            filetypes = [("Excel files", ["*.xlsx", "*.xlsm"])])
        """
        start_button.pack()
        
        #self.file_selected_label = tk.Label(self, text = self.file_to_read_in)

        self.progress = ttk.Progressbar(self, orient = HORIZONTAL, 
              length = 1000, mode = 'indeterminate')
        
        self.progress.pack()



def create_network(excel_file):

    
    # Read in
    app.reading_in_label.pack()
    app.update_idletasks()
    
    # Processing
    wb = load_data(filename = excel_file)
    app.processing_label.pack()
    app.update_idletasks()
    for sheet in wb.sheetnames:
        app.sheet_list.insert(END, sheet)
    app.update_idletasks()

    #app.progress.step(10)

    # so want to load it and then separately 
    # produce checklist to select and then
    # do the create network 
    # so create network split into two - select_sheets and create_network
    


    linked_sheets_dict = get_linked_sheets_dict(wb = wb)
    sheet_colors_dict = get_sheet_colors_dict(wb = wb)
    #app.progress.stop(10)
    linked_sheets_dict, sheet_colors_dict = delete_sheets_to_ignore(
        linked_sheets_dict = linked_sheets_dict, 
        sheet_colors_dict = sheet_colors_dict,
        sheets_to_ignore = sheets_to_ignore
    )
    edges = get_edges(linked_sheets_dict)
    nodes = get_nodes(sheet_colors_dict)

    # Create output directory
    app.saving_label.pack()
    create_output_directory(outdir = outdir)
    write_constants_file(edges = edges, 
                         nodes = nodes,
                         outfile = f"{outdir}/constants.js")    
    

    app.update_idletasks()

app = MainWindow()
#open(file=app.file_to_read_in)

app.mainloop()

#MainWindow.call_network_function(self=)
#app.geometry("1280x720")
#ani = animation.FuncAnimation(f, animate, interval=5000)



#main()

