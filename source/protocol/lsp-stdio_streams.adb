--  Copyright (c) 2017 Maxim Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
--  License-Filename: LICENSE
-------------------------------------------------------------

with GNAT.Sockets;
with Interfaces.C;
with Ada.Unchecked_Conversion;

package body LSP.Stdio_Streams is

   package C renames Interfaces.C;

   function To_Ada is new Ada.Unchecked_Conversion
     (Integer, GNAT.Sockets.Socket_Type);

   ----------
   -- Read --
   ----------

   procedure Read
     (Stream : in out Stdio_Stream;
      Item   : out Ada.Streams.Stream_Element_Array;
      Last   : out Ada.Streams.Stream_Element_Offset)
   is
      pragma Unreferenced (Stream);
      use type Ada.Streams.Stream_Element_Offset;

      function read
        (fildes : C.int;
         buf    : out Ada.Streams.Stream_Element_Array;
         nbyte  : C.size_t) return C.size_t
           with Import => True,
                Convention => C,
                External_Name => "read";
      Stdin   : constant GNAT.Sockets.Socket_Type := To_Ada (0);
      Request : GNAT.Sockets.Request_Type (GNAT.Sockets.N_Bytes_To_Read);
      Length  : Natural;
      Done    : C.size_t;
   begin
      GNAT.Sockets.Control_Socket (Stdin, Request);

      if Request.Size = 0 then
         Length := 1;
      else
         Length := Natural'Min (Item'Length, Request.Size);
      end if;

      Done := read (0, Item, C.size_t (Length));
      Last := Item'First + Ada.Streams.Stream_Element_Offset (Done) - 1;

      if Last < Item'First then
         raise Constraint_Error with "end of file";
      end if;
   end Read;

   -----------
   -- Write --
   -----------

   procedure Write
     (Stream : in out Stdio_Stream;
      Item   : Ada.Streams.Stream_Element_Array)
   is
      function write
        (fildes : C.int;
         buf    : Ada.Streams.Stream_Element_Array;
         nbyte  : C.size_t) return C.size_t
           with Import => True,
                Convention => C,
                External_Name => "write";
      pragma Unreferenced (Stream);

      Ignore : C.size_t := write (1, Item, Item'Length);
   begin
      null;
   end Write;

end LSP.Stdio_Streams;
