/***

User js logic

***/

var conversationReady = function () {
    window.USER_CHAT = 'loaded';
    /**
     * When the send message link on our home page is clicked
     * send an ajax request to our rails app with the sender_id and
     * recipient_id
     */
    $(document).on('click', '.start-conversation', function (e) {
        e.preventDefault();
        e.stopPropagation();

        var sender_id = $(this).data('sid');
        var recipient_id = $(this).data('rip');

        $.post("/conversations.js", { sender_id: sender_id, recipient_id: recipient_id }).done(function (data) {
            chatBox.chatWith(data.conversation_id);
        }).fail(function(){
            var defaultTime = 8000;
            $("#flash_conversation_error").slideDown().delay(defaultTime).queue(function(n) { $(this).slideUp(); n(); });
        });;
    });

    /**
     * Used to minimize the chatbox
     */

    $(document).on('click', '.toggleChatBox', function (e) {
        e.preventDefault();

        var id = $(this).data('cid');
        chatBox.toggleChatBoxGrowth(id);
    });

    /**
     * Used to close the chatbox
     */

    $(document).on('click', '.closeChat', function (e) {
        e.preventDefault();

        var id = $(this).data('cid');
        chatBox.close(id);
    });


    /**
     * Listen on keypress' in our chat textarea and call the
     * chatInputKey in chat.js for inspection
     */

    $(document).on('keydown', '.chatboxtextarea', function (event) {
        var id = $(this).data('cid');
        chatBox.checkInputKey(event, $(this), id);
    });

    /**
     * When a conversation link is clicked show up the respective
     * conversation chatbox
     */
    $(document).on('click', 'a.conversation', function (e) {
        e.preventDefault();

        var conversation_id = $(this).data('cid');
        chatBox.chatWith(conversation_id);
    });


}

// Avoid multiple bindings
if(typeof USER_CHAT === 'undefined'){
    // conversationReady();
    $(document).ready(conversationReady);
    // $(document).on("page:load", conversationReady);
}
