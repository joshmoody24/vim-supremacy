diff --git a/.bashrc b/.bashrc
index e69de29..f4d3e1a 100644
--- a/.bashrc
+++ b/.bashrc
@@ -1,3 +1,14 @@
+# added manually
+set -o vi
+bind '"jk":vi-movement-mode'
+
+function set-title() {
+  if [[ -z "$ORIG" ]]; then
+    ORIG=$PS1
+  fi
+  TITLE="\[\e]2;$*\a\]"
+  PS1=${ORIG}${TITLE}
+}
