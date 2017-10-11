with LSP.Messages;

package LSP.Message_Handlers is
   pragma Preelaborate;

   type Request_Handler is limited interface;
   type Request_Handler_Access is access all Request_Handler'Class;

   not overriding procedure Initialize_Request
    (Self     : access Request_Handler;
     Value    : LSP.Messages.InitializeParams;
     Response : in out LSP.Messages.Initialize_Response) is null;

   type Notification_Handler is limited interface;
   type Notification_Handler_Access is access all Notification_Handler'Class;

   not overriding procedure Exit_Notification
    (Self : access Notification_Handler) is null;

end LSP.Message_Handlers;