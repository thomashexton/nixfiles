{ config, pkgs, lib, ... }:

{
  environment.systemPackages = [ pkgs.deskflow ];

  # Deskflow server config (screen layout)
  environment.etc."Deskflow/Deskflow.conf".text = ''
    section: screens
        hxtn:
        work-laptop:
    end

    section: links
        hxtn:
            up = work-laptop
        work-laptop:
            down = hxtn
    end

    section: options
        # TODO: consider adding a keystroke to lock cursor to screen
        # if it becomes annoying losing the mouse to hxtn when not in use
        # keystroke(super+shift+l) = lockCursorToScreen(toggle)
    end
  '';
}
