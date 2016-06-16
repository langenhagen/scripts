FasdUAS 1.101.10   ��   ��    k             l     ��  ��    - ' todo set the focus to the right window     � 	 	 N   t o d o   s e t   t h e   f o c u s   t o   t h e   r i g h t   w i n d o w   
  
 l     ��  ��    : 4 make agnostic to usages like ./XXX or ../ and so on     �   h   m a k e   a g n o s t i c   t o   u s a g e s   l i k e   . / X X X   o r   . . /   a n d   s o   o n   ��  i         I     �� ��
�� .aevtoappnull  �   � ****  o      ���� 0 argv  ��    k     �       l     ��������  ��  ��        l     ��  ��    : 4 determine whether to use absolute or relative paths     �   h   d e t e r m i n e   w h e t h e r   t o   u s e   a b s o l u t e   o r   r e l a t i v e   p a t h s      l     ��������  ��  ��        r          n      ! " ! 4    �� #
�� 
cobj # m    ����  " o     ���� 0 argv     o      ���� 0 pwdpath     $ % $ r     & ' & c    
 ( ) ( m     * * � + +   ) m    	��
�� 
TEXT ' o      ���� 0 subpath   %  , - , r     . / . c     0 1 0 m     2 2 � 3 3   1 m    ��
�� 
TEXT / o      ���� 0 firstletter   -  4 5 4 l    6 7 8 6 r     9 : 9 c     ; < ; m     = = � > >   < m    ��
�� 
TEXT : o      ���� 
0 mypath   7 0 * item 1 will be set to (pwd) by fishconfig    8 � ? ? T   i t e m   1   w i l l   b e   s e t   t o   ( p w d )   b y   f i s h c o n f i g 5  @ A @ l   ��������  ��  ��   A  B C B Z    ; D E���� D ?      F G F l    H���� H I   �� I��
�� .corecnte****       **** I o    ���� 0 argv  ��  ��  ��   G m    ����  E k   # 7 J J  K L K l  # #�� M N��   M M G set subpath and firstletter if a second command line argument is given    N � O O �   s e t   s u b p a t h   a n d   f i r s t l e t t e r   i f   a   s e c o n d   c o m m a n d   l i n e   a r g u m e n t   i s   g i v e n L  P Q P r   # ) R S R n   # ' T U T 4   $ '�� V
�� 
cobj V m   % &����  U o   # $���� 0 argv   S o      ���� 0 subpath   Q  W�� W r   * 7 X Y X n   * 5 Z [ Z 7  + 5�� \ ]
�� 
ctxt \ m   / 1����  ] m   2 4����  [ o   * +���� 0 subpath   Y o      ���� 0 firstletter  ��  ��  ��   C  ^ _ ^ l  < <��������  ��  ��   _  ` a ` l  < <�� b c��   b ; 5 adjust pwdpath, subpath and finally mypath variables    c � d d j   a d j u s t   p w d p a t h ,   s u b p a t h   a n d   f i n a l l y   m y p a t h   v a r i a b l e s a  e f e l  < <��������  ��  ��   f  g h g Z   < � i j k�� i G   < G l m l =   < ? n o n o   < =���� 0 firstletter   o m   = > p p � q q   m =   B E r s r o   B C���� 0 firstletter   s m   C D t t � u u  . j k   J q v v  w x w l  J J�� y z��   y > 8 use relative paths: can concatenate pwdpath and subpath    z � { { p   u s e   r e l a t i v e   p a t h s :   c a n   c o n c a t e n a t e   p w d p a t h   a n d   s u b p a t h x  | } | l  J J�� ~ ��   ~ 4 . make subpath == "./XXX" => "XXX" or "." => ""     � � � \   m a k e   s u b p a t h   = =   " . / X X X "   = >   " X X X "   o r   " . "   = >   " " }  � � � l  J J��������  ��  ��   �  � � � r   J M � � � m   J K����  � o      ���� 0 beg   �  � � � Z   N o � ��� � � @   N U � � � l  N S ����� � I  N S�� ���
�� .corecnte****       **** � o   N O���� 0 subpath  ��  ��  ��   � o   S T���� 0 beg   � r   X i � � � n   X g � � � 7  Y g�� � �
�� 
TEXT � o   ] _���� 0 beg   � l  ` f ����� � I  ` f�� ���
�� .corecnte****       **** � o   a b���� 0 subpath  ��  ��  ��   � o   X Y���� 0 subpath   � o      ���� 0 subpath  ��   � r   l o � � � m   l m � � � � �   � o      ���� 0 subpath   �  ��� � l  p p��������  ��  ��  ��   k  � � � =   t y � � � o   t u���� 0 firstletter   � m   u x � � � � �  / �  ��� � k   | � � �  � � � l  | |�� � ���   � < 6 subpath is an absolute path - dont care about pwdpath    � � � � l   s u b p a t h   i s   a n   a b s o l u t e   p a t h   -   d o n t   c a r e   a b o u t   p w d p a t h �  � � � l  | |��������  ��  ��   �  � � � r   | � � � � m   |  � � � � �   � o      ���� 0 pwdpath   �  ��� � l  � ���������  ��  ��  ��  ��  ��   h  � � � l  � ���������  ��  ��   �  � � � r   � � � � � b   � � � � � o   � ����� 0 pwdpath   � o   � ����� 0 subpath   � o      ���� 
0 mypath   �  � � � l  � ���������  ��  ��   �  � � � l  � ���������  ��  ��   �  � � � l  � ��� � ���   �   open the mypath    � � � �     o p e n   t h e   m y p a t h �  � � � l  � ���������  ��  ��   �  � � � O   � � � � � k   � � � �  � � � l  � ���������  ��  ��   �  � � � I  � ��� ���
�� .aevtodocnull  �    alis � l  � � ����� � c   � � � � � o   � ����� 
0 mypath   � m   � ���
�� 
psxf��  ��  ��   �  � � � l  � ���������  ��  ��   �  � � � O   � � � � � O   � � � � � I  � ��� ���
�� .prcsclicnull��� ��� uiel � n   � � � � � 4   � ��� �
�� 
menI � m   � � � � � � � " M e r g e   A l l   W i n d o w s � n   � � � � � 4   � ��� �
�� 
menE � m   � � � � � � �  W i n d o w � 4   � ��� �
�� 
mbar � m   � ��� ��   � 4   � ��~ �
�~ 
prcs � m   � � � � � � �  F i n d e r � m   � � � ��                                                                                  sevs  alis    �  Macintosh HD               �(��H+   12GSystem Events.app                                               4E����;        ����  	                CoreServices    �(��      ���     12G 12F 12E  =Macintosh HD:System: Library: CoreServices: System Events.app   $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��   �  � � � l  � ��}�|�{�}  �|  �{   �  � � � l  � ��z�y�x�z  �y  �x   �  � � � l  � � � � � � I  � ��w�v�u
�w .miscactvnull��� ��� obj �v  �u   �   bring to front    � � � �    b r i n g   t o   f r o n t �  ��t � l  � ��s�r�q�s  �r  �q  �t   � m   � � � ��                                                                                  MACS  alis    t  Macintosh HD               �(��H+   12G
Finder.app                                                      3�h�p�Z        ����  	                CoreServices    �(��      �p�J     12G 12F 12E  6Macintosh HD:System: Library: CoreServices: Finder.app   
 F i n d e r . a p p    M a c i n t o s h   H D  &System/Library/CoreServices/Finder.app  / ��   �  � � � l  � ��p�o�n�p  �o  �n   �  ��m � l  � ��l�k�j�l  �k  �j  �m  ��       
�i � � � � � ��h�g�f�i   � �e�d�c�b�a�`�_�^
�e .aevtoappnull  �   � ****�d 0 pwdpath  �c 0 subpath  �b 0 firstletter  �a 
0 mypath  �` 0 beg  �_  �^   � �] �\�[ � �Z
�] .aevtoappnull  �   � ****�\ 0 argv  �[   � �Y�Y 0 argv    �X�W *�V�U 2�T =�S�R�Q p t�P�O � � � ��N�M ��L ��K�J ��I ��H�G
�X 
cobj�W 0 pwdpath  
�V 
TEXT�U 0 subpath  �T 0 firstletter  �S 
0 mypath  
�R .corecnte****       ****
�Q 
ctxt
�P 
bool�O 0 beg  
�N 
psxf
�M .aevtodocnull  �    alis
�L 
prcs
�K 
mbar
�J 
menE
�I 
menI
�H .prcsclicnull��� ��� uiel
�G .miscactvnull��� ��� obj �Z ՠ�k/E�O��&E�O��&E�O��&E�O�j 	k ��l/E�O�[�\[Zk\Zk2E�Y hO�� 
 �� �& ,mE�O�j 	� �[�\[Z�\Z�j 	2E�Y �E�OPY �a   a E�OPY hO��%E�Oa  ?�a &j Oa  &*a a / *a k/a a /a a /j UUO*j OPUOP � � � / U s e r s / l a n g e n h a / c o d e / o l y m p i a - p r i m e / b u i l d / a u t o - c o r e - s d k / s d k _ e x t e n s i o n s / t e s t s / u n i t / � �  . � � � / U s e r s / l a n g e n h a / c o d e / o l y m p i a - p r i m e / b u i l d / a u t o - c o r e - s d k / s d k _ e x t e n s i o n s / t e s t s / u n i t /�h �g  �f   ascr  ��ޭ