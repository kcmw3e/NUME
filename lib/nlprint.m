function nlprint(msg, varargin)
    arguments
        msg = "";
    end
    arguments (Repeating)
        varargin;
    end
    fprintf(msg + "\n", varargin{:});
end