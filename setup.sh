#!/bin/bash
set -eu                # Always put this in Bourne shell scripts
IFS=$(printf '\n\t')  # Always put this in Bourne shell scripts

#Install necessary software
sudo apt-get install \
                     cpanminus \
                     carton

#Install the libraries in our cpanfile locally
carton install

if [ -d .git ]
    then
        #Setup hooks to run perltidy on git commit
        #<<- lets the heredoc ignore leading tabs so we can indent here for 
        # clarity
        cat > .git/hooks/pre-commit <<- 'EOF'
        
        #!/bin/bash
        find . \
            -maxdepth 1 \
            -type f \
            \( -iname '*.pl' -or -iname '*.pm' \) \
            -print0 \
                |
                xargs \
                    -0 \
                    -I{} \
                    -P0 \
                    sh -c 'perltidy --perl-best-practices -nst -b {}'
EOF
fi
    
chmod +x .git/hooks/pre-commit