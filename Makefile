SRCS = $(shell find -name '*.cpp')
OBJ_DIR = Objects
OBJS = $(addprefix $(OBJ_DIR)/,$(SRCS:.cpp=.o))
CC = c++
CFLAGS = -Wall -Wextra -Werror -std=c++98
NAME = inception
TOTAL_FILES = $(words $(SRCS))

all: $(NAME)

$(OBJ_DIR)/%.o: %.cpp
	@tput civis
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) -c -g $< -o $@
	count=$$(find $(OBJ_DIR) -name '*.o' | wc -l); \
	str="████████████████████"; \
	len_str=$$((($$count * 20) / $(TOTAL_FILES) * 3)); \
	len_space=$$(((20 - $$len_str / 3) + 1)); \
	printf "\033[36m%.*s%*c\033[0m%% %d\r" $$len_str $$str $$len_space ' ' $$((($$count * 100) / $(TOTAL_FILES))); \

$(NAME): $(OBJS)
	@printf "\033[2K\r"
	@$(CC) $(CFLAGS) $(OBJS) -o $(NAME)
	@echo -n "   \033[37;46;1m$(NAME) created\033[0m\n"
	@tput cnorm

run: $(NAME)
	./$(NAME)

clean:
	@rm -rf $(OBJS) $(OBJ_DIR)
	@echo "   \033[41;1mObject file deleted\033[0m"

fclean: clean
	@rm -rf $(NAME)
	@echo "   \033[41;1m$(NAME) deleted\033[0m"

re: fclean all

.SILENT:
.PHONY: all clean fclean re run 
