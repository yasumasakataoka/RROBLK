// Needs Ten.js
new Ten.Observer(
    window,
    'onload', 
    function(){
        var form      = document.getElementById('comment-form');
        var submit_button = document.getElementById('comment-form-button');
        var message_p = Ten.DOM.getElementsByTagAndClassName('p', 'message', form)[0];
        // ���޽��֡�hatena2-white.css �� p.message { padding: 1em }
        // �ǥ�å������ξ夬��̯�˳����Ƥ��ޤ��Τ�
        message_p.style.padding = '3px';

        // ���顼��å����������ˤ���Ф���������
        // firefox �Ǥ�ư������������Ǥ����ʤ�¾�Ǥ�ƥ��Ȥ��ʤ���
        if (message_p.hasChildNodes()) {
            document.location.href = '#error-message';
        }

        
        // On submitTextInputDescription
        function tid_verifier(tid, str) {
            var is_inserted = false;
            var text = document.createTextNode(str);
            var br   = document.createElement('br');
            
            // Verifier
            return function() {             
                if (tid.isDefault()) {
                    if (!is_inserted) {
                        message_p.appendChild(text);
                        message_p.appendChild(br);
                        message_p.style.display = 'block';          
                        is_inserted = true;
                    }
                    return false;
                }
                else {
                    if (is_inserted) {
                        message_p.removeChild(text);
                        message_p.removeChild(br);
                        if (!message_p.hasChildNodes())
                            message_p.style.display = 'none';
                        is_inserted = false;
                    }
                    return true;
                }
            };
        }
        
        var fv = new FormVerifier(form,submit_button);
        var e;
        
        e = document.getElementById('comment-textarea');
        if (e) 
            fv.addVerifier(tid_verifier(new TextInputDescription(e, form, ''), '�����Ȥ����Ϥ��Ʋ�������'));
        e = document.getElementById('comment-username');
        if (e) 
            fv.addVerifier(tid_verifier(new TextInputDescription(e, form, '�ʤޤ�'), '̾�������Ϥ��Ʋ�������'));
        e = document.getElementById('comment-usermail');
        if (e)
            new TextInputDescription(e, form, '�᡼��(�����)');
        e = document.getElementById('comment-userurl');
        if (e)
            new TextInputDescription(e, form, 'URL');
        e = document.getElementById('comment-captcha');
        if (e)
            fv.addVerifier(tid_verifier(new TextInputDescription(e, form, '�������ʸ��������Ϥ��Ʋ�����'), '������ʸ��������Ϥ��Ƥ�������'));
});


