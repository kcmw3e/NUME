function check_folder(folder)
    arguments
        folder string;
    end
    
    if (~isfolder(folder))
        nlprint("'%s' does not exist, aborting.", folder);
        error("Missing folder.");
    else
        nlprint("'%s' exists", folder);
    end
end
